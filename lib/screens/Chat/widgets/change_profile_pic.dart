import 'dart:io';

import 'package:chatappp_socketio/services/auth_service.dart';
import 'package:chatappp_socketio/utils/gallery_utils.dart';
import 'package:chatappp_socketio/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class ProfilePicUpdateScreen extends StatefulWidget {
  const ProfilePicUpdateScreen({super.key});

  @override
  State<ProfilePicUpdateScreen> createState() => _ProfilePicUpdateScreenState();
}

class _ProfilePicUpdateScreenState extends State<ProfilePicUpdateScreen> {
  XFile? image;

  Future selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  File? _file;

  Uint8List webImage = Uint8List(10);

  uploadImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _file = selected;
        });
      } else {
        if (context.mounted) {
          showSnackBar(context, 'No image selected');
        }
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          // _file = File("a");
          webImage = f;
        });
      } else {
        if (context.mounted) {
          showSnackBar(context, 'No image selected');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 2, 74, 5),
        title: const Text(
          'Update Profile Pic',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        TextButton.icon(
          label: const Text('Select Profile Pic'),
          onPressed: () async {
            selectImage()
                .then((value) async => {
                      await Provider.of<AuthMethods>(context, listen: false)
                          .updateProfilePic(
                              context: context, file: File(image!.path))
                    })
                .then((isupdated) => {print("The is updated is ${isupdated}")});
            // if (image != null) {
            // bool isupdated =
            // if (context.mounted) {
            //   if (isupdated) {
            //     Navigator.pop(context);
            //   } else {
            //     showSnackBar(context, "Upload Failed due to Internal Server");
            //   }
            // }
            // } else {
            //   showSnackBar(context, "Choose a Profile Image");
            // }
          },
          icon: const Icon(
            Icons.add_a_photo,
          ),
        ),
      ]),
    );
  }
}
