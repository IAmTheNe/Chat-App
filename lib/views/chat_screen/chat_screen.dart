import 'package:chat_app/configs/app_route.dart';
import 'package:chat_app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat_form.dart';
import 'your_conversation.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  static const routeName = '/chat';

  @override
  Widget build(BuildContext context) {
    final contact = ModalRoute.of(context)!.settings.arguments as Contact;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contact.displayName,
              style: TextStyle(fontSize: 16.sp),
            ),
            Text(
              '@${contact.email}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black38,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.video,
              size: 16.sp,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.phone,
              size: 16.sp,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: YourConversation(contact: contact),
          ),
          ChatFormField(contact: contact),
        ],
      ),
    );
  }
}
