import 'package:firebase_database/firebase_database.dart';
import 'package:myapp/models/post.dart';

class RTDBservice {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> storePost(Post post) async {
    await _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> loadPosts(String id) async {
    List<Post> items = [];
    Query query = _database.ref
        .child("posts")
        .orderByChild("user_id")
        .equalTo(id);
    final event = await query.once();
    var snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      
      values.forEach((key, value) {
        Post post = Post.fromJson(Map<String, dynamic>.from(value));
        items.add(post);
      });
    }

    return items;
  }
}
