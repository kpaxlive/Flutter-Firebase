import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker picker = ImagePicker();

  MediaService();

  Future<XFile?> getImageFromGallery() async {
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (file != null) {
      return file;
    }
    return null;
  }
}
