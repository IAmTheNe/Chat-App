// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String uid;
  final String displayName;
  final String email;
  final String avatar;
  Contact({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.avatar,
  });

  Contact copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? avatar,
  }) {
    return Contact(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }

  factory Contact.fromQueryDocumentSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> q,
  ) {
    return Contact(
      uid: q.id,
      displayName: q['displayName'],
      email: q['email'],
      avatar: q['avatar'],
    );
  }
}
