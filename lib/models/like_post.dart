import 'package:fe_nhom2/models/post_post.dart';
class Like {
  int? id;
  int? postId;
  String? userId;
  Post? post;
  String? user;
  DateTime? likedAt;

  Like({
    this.id,
    this.postId,
    this.userId,
    this.post,
    this.user,
    this.likedAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
    id: json["id"] as int?,
    postId: json["postId"] as int?,
    userId: json["userId"] as String?,
    post: json["post"] != null ? Post.fromJson(json["post"]) : null,
    user: json["user"] as String?,
    likedAt: json["likedAt"] != null
        ? DateTime.parse(json["likedAt"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "postId": postId,
    "userId": userId,
    "post": post?.toJson(),
    "user": user,
    "likedAt": likedAt?.toIso8601String(),
  };
}