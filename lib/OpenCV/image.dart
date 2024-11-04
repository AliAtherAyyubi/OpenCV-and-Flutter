import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImageController {
  ///
  Future<File?> pickImage() async {
    final File imageFile;
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      File? compressFile = await compressImage(imageFile);
      return compressFile;
    }
  }

  ///
  /////
  Future<File?> compressImage(File imageFile,
      {int quality = 80, int maxWidth = 600}) async {
    try {
      // Read the image as bytes
      Uint8List imageBytes = await imageFile.readAsBytes();

      // Decode the image
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) return null;

      // Resize the image to the maxWidth while maintaining the aspect ratio
      img.Image resizedImage = img.copyResize(image, width: maxWidth);

      // Compress the image to the given quality
      List<int> compressedImageBytes =
          img.encodeJpg(resizedImage, quality: quality);

      // Save the compressed image as a new file
      File compressedFile =
          await File(imageFile.path).writeAsBytes(compressedImageBytes);

      return compressedFile;
    } catch (e) {
      print("Error compressing image: $e");
      return null;
    }
  }
}
