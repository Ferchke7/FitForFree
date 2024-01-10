class Post {
  final int id;
  final int userId;
  final String titleName;
  final String author; // Added author field
  final int visitors; // Updated from visiters to visitors
  final int likes;
  final String description;
  final DateTime createDate;
  final DateTime updateDate;
  List<dynamic> postsComments;

  Post({
    required this.id,
    required this.userId,
    required this.titleName,
    required this.author,
    required this.visitors,
    required this.likes,
    required this.description,
    required this.createDate,
    required this.updateDate,
    required this.postsComments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      titleName: json['titleName'] ?? '',
      author: json['author'] ?? '',
      visitors: json['visitors'] ?? 0,
      likes: json['likes'] ?? 0,
      description: json['description'] ?? '',
      createDate: DateTime.parse(json['createDate'] ?? ''),
      updateDate: DateTime.parse(json['updateDate'] ?? ''),
      postsComments: json['postsComments'] ?? [],
    );
  }
}
