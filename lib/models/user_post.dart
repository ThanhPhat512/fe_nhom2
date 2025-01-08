import 'comment_post.dart';
import 'like_post.dart';

class User {
  String? id;
  String? userName;
  String? normalizedUserName;
  String? email;
  String? normalizedEmail;
  bool? emailConfirmed;
  String? passwordHash;
  String? securityStamp;
  String? concurrencyStamp;
  String? phoneNumber;
  bool? phoneNumberConfirmed;
  bool? twoFactorEnabled;
  DateTime? lockoutEnd;
  bool? lockoutEnabled;
  int? accessFailedCount;
  String? fullName;
  DateTime? createdAt;
  String? avatar;
  String? initials;
  DateTime? dateOfBirth;
  double? height;
  double? weight;
  String? gender;
  String? activityLevel;
  List<Like>? likes;
  List<Comment>? comments;

  User({
    this.id,
    this.userName,
    this.normalizedUserName,
    this.email,
    this.normalizedEmail,
    this.emailConfirmed,
    this.passwordHash,
    this.securityStamp,
    this.concurrencyStamp,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.twoFactorEnabled,
    this.lockoutEnd,
    this.lockoutEnabled,
    this.accessFailedCount,
    this.fullName,
    this.createdAt,
    this.avatar,
    this.initials,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.gender,
    this.activityLevel,
    this.likes,
    this.comments,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userName: json["userName"],
    normalizedUserName: json["normalizedUserName"],
    email: json["email"],
    normalizedEmail: json["normalizedEmail"],
    emailConfirmed: json["emailConfirmed"],
    passwordHash: json["passwordHash"],
    securityStamp: json["securityStamp"],
    concurrencyStamp: json["concurrencyStamp"],
    phoneNumber: json["phoneNumber"],
    phoneNumberConfirmed: json["phoneNumberConfirmed"],
    twoFactorEnabled: json["twoFactorEnabled"],
    lockoutEnd: json["lockoutEnd"] != null
        ? DateTime.parse(json["lockoutEnd"])
        : null,
    lockoutEnabled: json["lockoutEnabled"],
    accessFailedCount: json["accessFailedCount"],
    fullName: json["fullName"],
    createdAt: json["createdAt"] != null
        ? DateTime.parse(json["createdAt"])
        : null,
    avatar: json["avatar"],
    initials: json["initials"],
    dateOfBirth: json["dateOfBirth"] != null
        ? DateTime.parse(json["dateOfBirth"])
        : null,
    height: (json["height"] ?? 0).toDouble(),
    weight: (json["weight"] ?? 0).toDouble(),
    gender: json["gender"],
    activityLevel: json["activityLevel"],
    likes: json["likes"] != null
        ? List<Like>.from(json["likes"].map((x) => Like.fromJson(x)))
        : [],
    comments: json["comments"] != null
        ? List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userName": userName,
    "normalizedUserName": normalizedUserName,
    "email": email,
    "normalizedEmail": normalizedEmail,
    "emailConfirmed": emailConfirmed,
    "passwordHash": passwordHash,
    "securityStamp": securityStamp,
    "concurrencyStamp": concurrencyStamp,
    "phoneNumber": phoneNumber,
    "phoneNumberConfirmed": phoneNumberConfirmed,
    "twoFactorEnabled": twoFactorEnabled,
    "lockoutEnd": lockoutEnd?.toIso8601String(),
    "lockoutEnabled": lockoutEnabled,
    "accessFailedCount": accessFailedCount,
    "fullName": fullName,
    "createdAt": createdAt?.toIso8601String(),
    "avatar": avatar,
    "initials": initials,
    "dateOfBirth": dateOfBirth?.toIso8601String(),
    "height": height,
    "weight": weight,
    "gender": gender,
    "activityLevel": activityLevel,
    "likes": likes?.map((x) => x.toJson()).toList(),
    "comments": comments?.map((x) => x.toJson()).toList(),
  };
}
