
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_2/models/comment_model.dart';


class PostModel {
  String? postID;
  String? postOwnerId;
  String? postOwnerMail;
  String? postImageUrl;
  Timestamp? postTimestamp;
  List<Comment>? comments;

  PostModel(
      {
      this.postID,
      required this.postOwnerId,
      required this.postOwnerMail,
      required this.postImageUrl,
      required this.postTimestamp,
      required this.comments});

  PostModel.fromJson(Map<String, dynamic> json) {
    postID = json['postID'];
    postOwnerId = json['postOwnerId'];
    postOwnerMail = json['postOwnerMail'];
    postImageUrl = json['postOwnerUrl'];
    postTimestamp = json['postTimestamp'];
    comments = json['comments']
        ?.map<Comment>((commentJson) => Comment.fromJson(commentJson))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postID'] = postID;
    data['postOwnerId'] = postOwnerId;
    data['postOwnerMail'] = postOwnerMail;
    data['postOwnerUrl'] = postImageUrl;
    data['postTimestamp'] = postTimestamp;
    data['comments'] = comments ?? [];
    return data;
  }
}
