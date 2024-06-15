import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/components/image_containers.dart';
import 'package:task_2/models/post_model.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/database_service.dart';
import 'package:task_2/services/media_service.dart';
import 'package:task_2/services/navigation_service.dart';
import 'package:task_2/services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt getIt = GetIt.instance;

  late final MediaService mediaService;
  late final AuthService auth;
  late final DatabaseService databaseService;
  late final StorageService storageService;
  late final NavigationService navigationService;

  @override
  void initState() {
    super.initState();
    mediaService = getIt.get<MediaService>();
    auth = getIt.get<AuthService>();
    databaseService = getIt.get<DatabaseService>();
    storageService = getIt.get<StorageService>();
    navigationService = getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationService.pushNamed('/sharePage'),
        child: const Icon(
          Icons.add_a_photo_outlined,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 67, 78),
        title: Text(
          "TIMELINE",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade100),
        ),
        actions: [
          IconButton(
              onPressed: () {
                auth.logOut();
              },
              icon: Icon(
                Icons.logout,
                size: 30,
                color: Colors.grey.shade100,
              )),
        ],
      ),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: buildPosts(),
    );
  }

  Widget buildPosts() {
    return StreamBuilder(
        stream: databaseService.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Unable to load data.."));
          }
          print(snapshot.data);
          if (snapshot.hasData) {
            final posts = snapshot.data!.docs;
            return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  PostModel post = posts[index].data();
                  return ImageContainers(post: post);
                });
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
