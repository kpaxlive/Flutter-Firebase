import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_2/models/post_model.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/database_service.dart';
import 'package:task_2/services/media_service.dart';
import 'package:task_2/services/navigation_service.dart';
import 'package:task_2/services/storage_service.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  final GetIt getIt = GetIt.instance;

  late final MediaService mediaService;
  late final AuthService auth;
  late final DatabaseService databaseService;
  late final NavigationService navigationService;
  late final StorageService storageService;

  bool isShow = true;
  bool isAdded = false;
  XFile? pickedImage;

  @override
  void initState() {
    mediaService = getIt.get<MediaService>();
    auth = getIt.get<AuthService>();
    databaseService = getIt.get<DatabaseService>();
    storageService = getIt.get<StorageService>();
    navigationService = getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> addPost() async {
      setState(() {
        isShow = false;
      });

      if (pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select an image")));
        return true;
      }

      String? imageUrl = await storageService.uploadPostImage(pickedImage!);
      print(imageUrl);

      if (imageUrl == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Image upload failed")));
        return false;
      }

      DateTime now = DateTime.now();

      // Create the post without postId
      PostModel post = PostModel(
        postOwnerId: auth.user!.uid,
        postOwnerMail: auth.user!.email,
        postImageUrl: imageUrl,
        postTimestamp: Timestamp.fromDate(now),
        comments: [],
      );

      // Add the post to the database and get the postId
      String postID = await databaseService.createPost(postModel: post);

      // Update the post with postId
      post.postID = postID;

      // Update the post in the database with the postId
      await databaseService.updatePost(postModel: post);
      print("POST ID = ${post.postID}");

      pickedImage = null;
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SHARE POST",
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 26, 67, 78),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            pickedImage = null;
            navigationService.goBack();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 300,
                width: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: pickedImage != null
                        ? FileImage(File(pickedImage!.path))
                        : const AssetImage("assets/images/gallery.jpg")
                            as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: isShow ? Colors.teal.shade200 : Colors.grey.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: isShow ? Colors.teal.shade700 : Colors.grey.shade700,
                    )),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_a_photo_outlined,
                    size: 60,
                  ),
                  onPressed: !isShow
                      ? null
                      : () async {
                          pickedImage = await mediaService.getImageFromGallery();
                          if (pickedImage != null) {
                            setState(() {});
                          }
                        },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: !isShow
                    ? null
                    : () async {
                        isAdded = await addPost();
                        if (isAdded) {
                          setState(() {
                            isShow = true;
                            isAdded = false;
                          });
                        }
                      },
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: isShow
                          ? Color.fromARGB(255, 26, 67, 78)
                          : Colors.grey.shade300,
                      border: Border.all(
                          width: 3,
                          color: isShow
                              ? Colors.green.shade300
                              : Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(35)),
                  child: const Center(
                    child: Text(
                      "Share Post",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
