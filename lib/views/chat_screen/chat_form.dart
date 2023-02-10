import 'dart:io';

import 'package:chat_app/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/firestore_service.dart';
import '../../utils/image_helper.dart';

class ChatFormField extends StatefulWidget {
  const ChatFormField({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  State<ChatFormField> createState() => _ChatFormFieldState();
}

class _ChatFormFieldState extends State<ChatFormField> {
  late final TextEditingController _messageController;
  String content = '';
  List<File> image = [];

  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  void onSendMessage() async {
    FocusScope.of(context).unfocus();
    await FirebaseFirestoreService.instance.sendMessage(
      message: content,
      userSendId: FirebaseAuth.instance.currentUser!.uid,
      userReceiveId: widget.contact.uid,
      createdAt: Timestamp.now(),
      files: image,
    );
    _messageController.clear();
    setState(() {
      content = '';
      image = [];
    });
  }

  void selectImage([ImageSource source = ImageSource.gallery]) async {
    ImagePickerHelper picker = ImagePickerHelper();

    final files = await picker.pickImage(
      source: source,
    );
    setState(() {
      image = files.map((file) {
        return File(file.path);
      }).toList();
    });

    onSendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white60,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => selectImage(ImageSource.camera),
            icon: const Icon(
              Icons.camera_alt,
            ),
          ),
          IconButton(
            onPressed: selectImage,
            icon: const Icon(
              Icons.photo_library,
            ),
          ),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: .2.sh,
              ),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _messageController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your message...',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
                onChanged: (val) => {
                  setState(() {
                    content = val;
                  })
                },
              ),
            ),
          ),
          IconButton(
            onPressed: content.isNotEmpty ? onSendMessage : null,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
    );
  }
}
