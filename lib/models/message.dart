// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String uid;
  final String fromUser;
  final String toUser;
  final String message;
  final Timestamp createdAt;
  final List? images;
  Message({
    required this.uid,
    required this.fromUser,
    required this.toUser,
    required this.message,
    required this.createdAt,
    required this.images,
  });

  Message copyWith({
    String? uid,
    String? fromUser,
    String? toUser,
    String? message,
    Timestamp? createdAt,
    List? images,
  }) {
    return Message(
      uid: uid ?? this.uid,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
    );
  }

  factory Message.fromQueryDocumentSnapshot(
    QueryDocumentSnapshot q,
  ) {
    return Message(
      uid: q.id,
      fromUser: q['fromUser'],
      toUser: q['toUser'],
      message: q['message'],
      createdAt: q['createdAt'],
      images: q['images'],
    );
  }

  static List<Message> allMessage(
    List<QueryDocumentSnapshot> l,
  ) {
    List<Message> lstMessage = [];

    for (var query in l) {
      lstMessage.add(Message.fromQueryDocumentSnapshot(query));
    }
    return lstMessage;
  }

  static List<Message> getMessagesWithCondition(
    List<Message> messages,
    String fromUser,
    String toUser,
  ) {
    List<Message> lstMessage = [];
    for (var msg in messages) {
      if (fromUser != toUser) {
        if (msg.fromUser == fromUser && msg.toUser == toUser) {
          lstMessage.add(msg);
        }
        if (msg.fromUser == toUser && msg.toUser == fromUser) {
          lstMessage.add(msg);
        }
      } else {
        if (msg.toUser == msg.fromUser) {
          lstMessage.add(msg);
        }
      }
    }

    lstMessage.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return lstMessage;
  }
}
