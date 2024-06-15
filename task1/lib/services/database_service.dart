import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_2/models/comment_model.dart';
import 'package:task_2/models/post_model.dart';

class DatabaseService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference<PostModel>? postCollection;

  DatabaseService() {
    setUpCollections();
  }

  void setUpCollections() {
    postCollection = fireStore.collection('posts').withConverter<PostModel>(
          fromFirestore: (snapshots, _) =>
              PostModel.fromJson(snapshots.data()!),
          toFirestore: (postModel, _) => postModel.toJson(),
        );
  }

  Future<String> createPost({required PostModel postModel}) async {
    DocumentReference<Object?>? docRef = await postCollection?.add(postModel);
    String postId = docRef!.id;

    return postId;
  }

  Future<void> updatePost({required PostModel postModel}) async {
    await fireStore
        .collection('posts')
        .doc(postModel.postID)
        .update(postModel.toJson());
  }

  Stream<QuerySnapshot<PostModel>> getPosts() {
    // ignore: unnecessary_cast
    return postCollection!
        .orderBy('postTimestamp', descending: true)
        .snapshots() as Stream<QuerySnapshot<PostModel>>;
  }

  Stream<PostModel> getPostById(String postId) {
    return postCollection!.doc(postId).snapshots().map((snapshot) {
      return snapshot.data()!;
    });
  }

  // Modified method to get comments for a specific post
Stream<List<Comment>> getComments(String postId) {
  return getPostById(postId).map((post) {
    final comments = post.comments ?? [];

    comments.sort((a, b) => b.commentTimestamp!.compareTo(a.commentTimestamp!));
    return comments;
  });
}

// Import your Comment model
  Future<void> addComment({
    required PostModel post,
    required User user,
    required String comment,
  }) async {
    if (post.postID!.isEmpty || comment.isEmpty) {
      throw Exception("Invalid post ID, user, or empty comment");
    }

    DocumentReference<PostModel> postRef = postCollection!.doc(post.postID);

    // Construct the updated data
    Map<String, dynamic> updatedData = {
      'comments': FieldValue.arrayUnion([
        {
          'commenterId': user.uid,
          'commenterMail': user.email,
          'commentTimestamp': Timestamp.now(),
          'comment': comment,
        }
      ])
    };

    // Update the 'comments' field within the post document
    await postRef.update(updatedData);
  }
}
