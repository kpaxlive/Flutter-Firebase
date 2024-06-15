import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:task_2/components/my_textfield.dart';
import 'package:task_2/models/post_model.dart';
import 'package:task_2/services/auth_service.dart';
import 'package:task_2/services/database_service.dart';
import 'package:task_2/services/navigation_service.dart';
import 'package:task_2/services/storage_service.dart';

class ImageContainers extends StatefulWidget {
  final PostModel post;
  const ImageContainers({super.key, required this.post});

  @override
  State<ImageContainers> createState() => _ImageContainersState();
}

class _ImageContainersState extends State<ImageContainers> {
  final GetIt getIt = GetIt.instance;
  late final AuthService auth;
  late final StorageService storageService;
  late final DatabaseService databaseService;
  late final NavigationService navigationService;

  TextEditingController controller = TextEditingController();

  bool isLiked = false;
  bool isDisliked = false;

  @override
  void initState() {
    auth = getIt.get<AuthService>();
    storageService = getIt.get<StorageService>();
    databaseService = getIt.get<DatabaseService>();
    navigationService = getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.topCenter,
          height: 320,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(4.0, 4.0),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(widget.post.postOwnerMail!),
                Flexible(
                  flex: 4,
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        isLiked = true;
                        isDisliked = false;
                      });
                    },
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.post.postImageUrl != null
                              ? CachedNetworkImageProvider(
                                  widget.post
                                      .postImageUrl!, // Ensure non-null URL
                                  cacheKey: widget.post
                                      .postImageUrl, // Unique identifier for caching
                                )
                              : const AssetImage("assets/images/gallery.jpg")
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.thumb_up_alt_rounded
                                    : Icons.thumb_up_alt_outlined,
                                color: isLiked
                                    ? Colors.blue.shade600
                                    : Colors.black,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  isLiked = !isLiked;
                                  if (isLiked == true) {
                                    isDisliked = false;
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 13),
                            IconButton(
                              icon: Icon(
                                isDisliked
                                    ? Icons.thumb_down_alt_rounded
                                    : Icons.thumb_down_alt_outlined,
                                color: isDisliked
                                    ? Colors.red.shade900
                                    : Colors.black,
                                size: 30,
                              ),
                              onPressed: () {
                                setState(() {
                                  isDisliked = !isDisliked;
                                  if (isDisliked) {
                                    isLiked = false;
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 13),
                            IconButton(
                                onPressed: () {
                                  bottomSheet(context);
                                },
                                icon: const Icon(Icons.comment, size: 30)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.downloading_sharp,
                            color: Colors.black,
                            size: 34,
                          ),
                          onPressed: () async {
                            print(widget.post.postImageUrl);
                            await storageService.downloadImageToLocalStorage(
                                widget.post.postImageUrl!);
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  PersistentBottomSheetController bottomSheet(BuildContext context) {
    return showBottomSheet(
        backgroundColor: const Color.fromARGB(255, 26, 67, 78),
        context: context,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
              child: Container(
                padding: const EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(
                            flex: 3,
                          ),
                          const Text(
                            "COMMENTS",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          TextButton(
                            onPressed: () => navigationService.goBack(),
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.purple.shade300, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: StreamBuilder(
                          stream:
                              databaseService.getComments(widget.post.postID!),
                          builder: (context, snapshot) {
                            final comments = snapshot.data ?? [];
                            return ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  return SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${comment.commenterMail}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              comment.comment!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Divider(
                                          thickness: 1,
                                          endIndent: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          color: Colors.grey.shade100,
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                    ),
                    const Divider(
                      thickness: 3,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                              fieldText: "Add comment..",
                              hide: false,
                              fieldControl: controller),
                        ),
                        IconButton(
                            onPressed: () async {
                              if (widget.post.postID == null ||
                                  widget.post.postID!.isEmpty == true) {
                                throw Exception("Missing or invalid post ID");
                              }

                              try {
                                if (controller.text.isNotEmpty) {
                                  await databaseService.addComment(
                                    post: widget.post,
                                    user: auth.user!,
                                    comment: controller.text,
                                  );
                                }
                                controller.clear();
                              } on Exception catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Comment couldn't add the post: ${e.toString()}")));
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 32,
                            )),
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
