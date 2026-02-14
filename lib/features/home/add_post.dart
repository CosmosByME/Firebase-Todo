import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/firebase/real_time_database.dart';
import 'package:myapp/services/firebase/storage_service.dart';
import 'package:myapp/services/shared_preference/prefs.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File? imageFile = null;
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void addPost() async {
    String title = titleController.text;
    String content = contentController.text;
    String imageUrl = '';

    if (imageFile != null) {
      imageUrl = await StorageService.uploadImage(imageFile!);
    }
    var id = await Prefs.loadUserId();
    await RTDBservice.storePost(
      Post(
        userId: id,
        title: title,
        content: content,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      ),
    );

    _respAddPost();
  }

  _respAddPost() {
    Navigator.of(context).pop({'data': 'done'});
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No image selected")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Post"), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: (imageFile != null)
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : Icon(
                          Icons.add_a_photo,
                          size: 25,
                          color: Colors.grey[700],
                        ),
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: "Title"),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: InputDecoration(hintText: "Content"),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  addPost();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: Size(250, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
