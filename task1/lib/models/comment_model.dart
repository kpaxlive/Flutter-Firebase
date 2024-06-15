import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? commenterId;
  String? commenterMail;
  Timestamp? commentTimestamp;
  String? comment;

  Comment(
      {required this.commenterId,
      required this.commenterMail,
      required this.commentTimestamp,
      required this.comment});

  Comment.fromJson(Map<String, dynamic> json) {
    commenterId = json['commenterId'];
    commenterMail = json['commenterMail'];
    commentTimestamp = json['commentTimestamp'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commenterId'] = commenterId;
    data['commenterMail'] = commenterMail;
    data['commentTimestamp'] = commentTimestamp;
    data['comment'] = comment;

    return data;
  }
}