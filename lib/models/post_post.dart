
import 'package:fe_nhom2/models/user_post.dart';

import 'comment_post.dart';
import 'like_post.dart';

class Post {
  final int id;
  final bool status;
  final String description;
  final String? image;
  final DateTime dateCreate;
  final User user;
  // final List<Like> likes;
  // final List<Comment> comments;
  final List<dynamic> likes;  // Mảng like

  Post({
    required this.id,
    required this.status,
    required this.description,
    this.image,
    required this.dateCreate,
    required this.user,
    // required this.likes,
    // required this.comments,
    required this.likes,

  });

  // Hàm chuyển đổi JSON thành đối tượng
  factory Post.fromJson(Map<String, dynamic> json) {
    print(json['likes'].runtimeType);  // Kiểm tra kiểu dữ liệu của 'likes'
    print(json['likes']);  // In ra toàn bộ danh sách likes để kiểm tra

    return Post(
      id: json['id'],
      status: json['status'],
      description: json['description'],
      image: json['image'],
      dateCreate: DateTime.parse(json['dateCreate']),
      user: User.fromJson(json['user']),
      likes: json['likes'] ?? [],  // Đảm bảo không có null

      // likes: (json['likes'] as List<dynamic>?)
      //     ?.map((like) => Like.fromJson(like))
      //     .toList() ?? [], // Trả về danh sách trống nếu 'likes' là null
      // comments: (json['comments'] as List<dynamic>?)
      //     ?.map((comment) => Comment.fromJson(comment))
      //     .toList() ?? [], // Trả về danh sách trống nếu 'comments' là nullg mặc định
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
      'likes': likes,

      // 'likes': likes.map((like) => like.toJson()).toList(),
      // 'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
  // Số lượng like
  int get likeCount => likes.length;
  bool isLikedByUser(String userId) {
    return likes.any((like) {
      if (like is Map) {
        return like['userId'] == userId;
      } else if (like is Like) {
        return like.userId == userId;
      }
      return false;
    });
  }


}
