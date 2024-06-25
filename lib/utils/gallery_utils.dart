import 'dart:io';
import 'dart:typed_data';

import 'package:chatappp_socketio/utils/snackbar.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImageFromGallery(BuildContext context) async {
  try {
    XFile? image;
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = pickedImage; //XFile(pickedImage.path);
    }
    return image;
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context, e.toString());
    }
  }
  return null;
}

Future<XFile?> pickVideoFromGallery(BuildContext context) async {
  XFile? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = pickedVideo;
    }
    return video;
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context, e.toString());
    }
  }
  return null;
}

Future<XFile?> pickFiles(BuildContext context) async {
  XFile? doc;
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['doc', 'docx', 'pdf', 'csv', '.exe']);

    if (result != null) {
      print('ITs here');
      doc = XFile(result.xFiles.first.path);
      print("the path is ${doc.path}");
    }
    // if (result != null) {
    //   Uint8List? fileBytes = result.files.first.bytes;
    //   String fileName = result.files.first.name;
    // }
    // final pickedFile =
    //     await ImagePicker().pi(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   doc = pickedFile;
    // }

    return doc;
  } catch (e) {
    if (context.mounted) {
      showSnackBar(context, e.toString());
    }
  }
  return null;
}

// Future<GiphyGif?> pickGIF(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     gif = await Giphy.getGif(
//       context: context,
//       apiKey: 'pwXu0t7iuNVm8VO5bgND2NzwCpVH9S0F',
//     );
//   } catch (e) {
//     showSnackBar(context, e.toString());
//   }
//   return gif;
// }
