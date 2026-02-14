class Post {
  String userId;
  String title;
  String content;

  Post({
    required this.userId,
    required this.title,
    required this.content,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
    };
  }
}
