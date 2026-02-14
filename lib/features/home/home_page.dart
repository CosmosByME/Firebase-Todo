import 'package:flutter/material.dart';
import 'package:myapp/features/home/add_post.dart';
import 'package:myapp/features/sign_up/sign_up_page.dart';
import 'package:myapp/models/post.dart';
import 'package:myapp/services/firebase/auth_service.dart';
import 'package:myapp/services/firebase/real_time_database.dart';
import 'package:myapp/services/shared_preference/prefs.dart';

class AllPostPage extends StatefulWidget {
  const AllPostPage({super.key});

  @override
  State<AllPostPage> createState() => _AllPostPageState();
}

class _AllPostPageState extends State<AllPostPage> {
  List<Post> items = [];

  @override
  void initState() {
    super.initState();
    _apiLoadPosts();
  }

  void _apiLoadPosts() async {
    final id = await Prefs.loadUserId();
    debugPrint(id);
    final posts = await RTDBservice.loadPosts(id);
    _respPosts(posts);
  }

  void _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  Future openDetail() async {
    Map result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPost()),
    );

    if (result != null && result['data'] == 'done') {
      _apiLoadPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Posts"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOutUser(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemList(post: items[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDetail();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final Post post;
  const ItemList({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text(
        post.content,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
