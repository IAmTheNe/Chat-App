import 'package:chat_app/configs/app_route.dart';
import 'package:chat_app/utils/firestore_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const routeName = '/search';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Find new contact',
          ),
          onChanged: (val) {
            setState(() {
              search = val;
            });
            FirebaseFirestoreService.instance.search(search);
          },
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestoreService.instance.search(search),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occured'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Not Found'),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final contact = snapshot.data![index];
              return ListTile(
                title: Text(contact.displayName),
                subtitle: Text(contact.email),
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      contact.avatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoute.chat,
                    arguments: contact,
                  );
                },
              );
            },
            itemCount: snapshot.data!.length,
          );
        },
      ),
    );
  }
}
