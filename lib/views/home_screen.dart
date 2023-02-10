import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../configs/app_route.dart';

import '../utils/firebase_auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: .2.sh,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => const ListTile(
                title: Text(
                  'Trần Nguyên Thế',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Ước gì mai mình đi Trà sữa Map! 🤡🤡🤡',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text('22:34'),
              ),
              childCount: 15,
            ),
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
