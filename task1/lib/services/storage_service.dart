import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_2/services/navigation_service.dart';

class StorageService {
  final GetIt getIt = GetIt.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  late final NavigationService navigationService;

  StorageService(){navigationService = getIt.get<NavigationService>();}

  Future<String?> uploadPostImage(XFile image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = storage.ref().child('posts/$fileName');
    UploadTask uploadTask = reference.putFile(File(image.path));
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }



  Future<void> downloadImageToLocalStorage(String imagePath) async {
    try {
      Dio dio = Dio();

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/${imagePath.split('/').last}';

      await dio.download(imagePath, savePath);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(navigationService.navigatorKey!.currentState!.context)
            .showSnackBar(const SnackBar(content: Text("Image downloaded succesfuly")));
      print('Dosya $savePath konumuna indirildi');
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(navigationService.navigatorKey!.currentState!.context)
            .showSnackBar(const SnackBar(content: Text("Image download failed")));
      print('Resim indirilirken hata oluştu: $e');
    }
  }
}
