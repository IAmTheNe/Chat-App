import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../extensions/timestamp_config.dart';
import '../../models/contact.dart';
import '../../models/message.dart';
import '../../utils/firebase_auth_services.dart';
import '../../utils/firestore_service.dart';
import '../../widgets/show_image.dart';

class YourConversation extends StatelessWidget {
  const YourConversation({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 8.w,
        right: 8.w,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestoreService.instance.fetchAllMessages(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final chatDocs = snapshot.data?.docs;
          final messages = Message.allMessage(chatDocs!);
          final conditionMessages = Message.getMessagesWithCondition(
            messages,
            FirebaseAuth.instance.currentUser!.uid,
            contact.uid,
          );
          if (conditionMessages.isEmpty) {
            return const Center(
              child: Text('No message'),
            );
          }
          return ListView.builder(
            reverse: true,
            itemBuilder: (context, index) {
              bool isMe = FirebaseAuth.instance.currentUser!.uid ==
                  conditionMessages[index].fromUser;
              final images = conditionMessages[index].images as List;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: images.isEmpty
                            ? BoxConstraints(
                                maxWidth: .6.sw,
                                minWidth: .3.sw,
                              )
                            : const BoxConstraints(),
                        padding: images.isEmpty
                            ? EdgeInsets.symmetric(
                                vertical: 10.0.h,
                                horizontal: 12.0.w,
                              )
                            : const EdgeInsets.only(),
                        decoration: images.isEmpty
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(.6),
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(.3),
                                  ],
                                ),
                              )
                            : const BoxDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (images.isEmpty)
                              Text(
                                conditionMessages[index].message,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
                            if (images.isNotEmpty)
                              Wrap(
                                spacing: 2,
                                children: [
                                  ...images
                                      .map(
                                        (e) => ShowImage(src: e),
                                      )
                                      .toList(),
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      FutureBuilder<User?>(
                        future: FirebaseAuthServices.instance!.getCurrentUser,
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            return CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(
                                isMe
                                    ? snapshot.data!.photoURL!
                                    : contact.avatar,
                              ),
                            );
                          }
                          return const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 10,
                            child: CircularProgressIndicator.adaptive(),
                          );
                        },
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        (conditionMessages[index].createdAt).toCustomTime(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
              );
            },
            itemCount: conditionMessages.length,
          );
        },
      ),
    );
  }
}
