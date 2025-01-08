import 'package:fe_nhom2/models/post_post.dart';

class Comment {
  int? id;
  int? postId;
  String? userId;
  String? content;
  bool? status;
  DateTime? createdAt;
  Post? post;
  String? user;

  Comment({
    this.id,
    this.postId,
    this.userId,
    this.content,
    this.status,
    this.createdAt,
    this.post,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    postId: json["postId"],
    userId: json["userId"],
    content: json["content"],
    status: json["status"],
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : null,
    post: json["post"] != null ? Post.fromJson(json["post"]) : null,
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "postId": postId,
    "userId": userId,
    "content": content,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "post": post?.toJson(),
    "user": user,
  };
}
