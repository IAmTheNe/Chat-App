import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../configs/app_route.dart';
import '../extensions/timestamp_config.dart';
import '../models/contact.dart';
import '../models/message.dart';
import '../utils/firebase_auth_services.dart';
import '../utils/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: const Text(
              'Chatty',
              style: TextStyle(
                letterSpacing: 2.4,
                color: Colors.white70,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                FirebaseAuthServices.instance!.signOut();
              },
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  child: CircleAvatar(
                    radius: 16,
                    child: FutureBuilder(
                      future: FirebaseAuthServices.instance!.getCurrentUser,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(snapshot.data!.photoURL!),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: FirebaseAuthServices.instance!.getCurrentUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
              final fromUser = snapshot.data!.uid;
              return StreamBuilder(
                stream: FirebaseFirestoreService.instance
                    .currentUserInformation(fromUser),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          snapshot.error.toString(),
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }
                  final contact = snapshot.data?['contact'] ?? [];
                  if (contact.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('No contact!'),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final toUser = contact[index];

                        return StreamBuilder(
                          stream: StreamZip(
                            [
                              FirebaseFirestoreService.instance
                                  .currentUserInformation(contact[index]),
                              FirebaseFirestoreService.instance
                                  .fetchAllMessages()
                            ],
                          ).asyncMap(
                            (event) => [
                              event[0],
                              event[1],
                            ],
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                            final user = snapshot.data?[0] as DocumentSnapshot?;

                            final chatDocs =
                                (snapshot.data?[1] as QuerySnapshot?)?.docs;
                            final messages = Message.allMessage(chatDocs!);
                            final conditionMessages =
                                Message.getMessagesWithCondition(
                              messages,
                              fromUser,
                              toUser,
                            );
                            var lastestMessage = conditionMessages.firstWhere(
                                (element) =>
                                    (element.fromUser == fromUser &&
                                        element.toUser == toUser) ||
                                    (element.fromUser == toUser &&
                                        element.toUser == fromUser));
                            return ListTile(
                              title: Text(
                                user?['displayName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                lastestMessage.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(lastestMessage.createdAt
                                  .toShorterCustomTime()),
                              leading: CircleAvatar(
                                child: ClipRRect(
                                  child: Image.network(
                                    user?['avatar'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoute.chat,
                                  arguments:
                                      Contact.fromDocumentSnapshot(user!),
                                );
                              },
                            );
                          },
                        );
                      },
                      childCount: contact == null ? 0 : contact.length,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoute.searchFriend);
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
