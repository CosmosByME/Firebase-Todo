class Post {
  String userId;
  String? imageUrl;
  String title;
  String content;

  Post({
    required this.userId,
    required this.title,
    required this.content,
    this.imageUrl
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
    };
  }
}
