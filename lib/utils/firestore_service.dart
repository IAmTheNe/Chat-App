import 'dart:io';

import 'package:chat_app/models/contact.dart';
import 'package:chat_app/utils/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  FirebaseFirestoreService._();

  static FirebaseFirestoreService? _instance;
  static FirebaseFirestoreService get instance =>
      _instance ?? FirebaseFirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void storeUser(User? user) async {
    final docRef = _db.collection('user').doc(user!.uid);
    await docRef.set(
      {
        'displayName': user.displayName,
        'email': user.email,
        'creationTime': user.metadata.creationTime,
        'contact': [],
        'avatar': user.photoURL ??
            'https://firebasestorage.googleapis.com/v0/b/chatty-app-c401c.appspot.com/o/avatars%2Fdefault%2Fdefault-avatar-profile-trendy-style-social-media-user-icon-187599373.jpg?alt=media&token=a0e3f474-b1ea-4e9f-a6c8-3aef7cb1b97c',
      },
      SetOptions(
        mergeFields: [
          'displayName',
          'email',
          'avatar',
          'creationTime',
        ],
      ),
    );
  }

  Stream<QuerySnapshot> fetchAllMessages() {
    return _db
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    String? message,
    required String userSendId,
    required String userReceiveId,
    required Timestamp createdAt,
    List<File>? files,
  }) async {
    final ref = _db.collection('chat').doc();
    final url = await FirebaseStorageServices.instance.uploadImage(
      ref.id,
      files,
    );
    addContactList(id1: userSendId, id2: userReceiveId);
    addContactList(id1: userReceiveId, id2: userSendId);
    await ref.set({
      'message': message?.trim(),
      'fromUser': userSendId,
      'toUser': userReceiveId,
      'createdAt': createdAt,
      'images': url,
    });
  }

  Future<List<Contact>> search(String name) async {
    if (name.isEmpty) return [];

    List<Contact> contacts = [];
    final query = await _db.collection('user').get();
    final find = query.docs.where((q) {
      return (q['displayName'] as String).contains(name);
    });
    for (var q in find) {
      contacts.add(
        Contact.fromQueryDocumentSnapshot(q),
      );
    }

    return contacts;
  }

  void addContactList({
    required String id1,
    required String id2,
  }) async {
    final docRef = _db.collection('user').doc(id1);
    final snapshot = await docRef.get();

    final contactList = snapshot.data()?['contact'] ?? [];
    if (contactList.isEmpty) {
      docRef.update({
        'contact': [
          id2,
        ]
      });
    } else {
      if (!contactList.contains(id2)) {
        docRef.update({
          'contact': [...contactList, id2]
        });
      }
    }
  }

  Stream<DocumentSnapshot> currentUserInformation([String? id]) {
    return _db
        .collection('user')
        .doc(id ?? FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }
}
