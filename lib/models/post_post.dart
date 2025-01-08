
import 'package:fe_nhom2/models/user_post.dart';

import 'comment_post.dart';
import 'like_post.dart';

class Post {
  final int id;
  final bool status;
  final String description;
  final String image;
  final DateTime dateCreate;
  final User user;
  final List<Like> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.status,
    required this.description,
    required this.image,
    required this.dateCreate,
    required this.user,
    required this.likes,
    required this.comments,
  });

  // Hàm chuyển đổi JSON thành đối tượng
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      status: json['status'],
      description: json['description'],
      image: json['image'],
      dateCreate: DateTime.parse(json['dateCreate']),
      user: User.fromJson(json['user']),
      likes: (json['likes'] as List<dynamic>)
          .map((like) => Like.fromJson(like))
          .toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }

  // Hàm chuyển đổi đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'description': description,
      'image': image,
      'dateCreate': dateCreate.toIso8601String(),
      'user': user.toJson(),
      'likes': likes.map((like) => like.toJson()).toList(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
