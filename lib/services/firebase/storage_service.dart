import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService {
  static final storage = FirebaseStorage.instance.ref();
  static final folder = "post_images";

  static Future<String?> uploadImage(File image) async {
    try {
      String imgName = "image_${DateTime.now()}";
      Reference ref = storage.child(folder).child(imgName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null; // Return null if upload fails
    }
  }
}