import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices {
  FirebaseStorageServices._();

  static FirebaseStorageServices? _instance;
  static FirebaseStorageServices get instance =>
      _instance ?? FirebaseStorageServices._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImage(
    String messengerId, [
    List<File>? files,
  ]) async {
    List<String> urls = [];

    if (files != null) {
      for (File file in files) {
        final ref = _storage
            .ref()
            .child('messager_image')
            .child(messengerId)
            .child('${DateTime.now().toIso8601String()}.jpg');
        final uploadTask = ref.putFile(file);
        await uploadTask.whenComplete(() async {
          final url = await ref.getDownloadURL();
          urls.add(url);
        });
      }
    }
    if (urls.isEmpty) return [];
    return [...urls];
  }
}
