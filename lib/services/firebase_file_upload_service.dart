import 'dart:async';
import 'dart:io';

import 'package:chatappp_socketio/utils/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageRepository({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(
      {required String ref,
      required XFile file,
      required BuildContext context}) async {
    try {
      // if (kIsWeb) {
      //   String downloadUrl = '';
      //   Reference _reference = firebaseStorage.ref().child(ref);
      //   await _reference
      //       .putData(
      //     await file!.readAsBytes(),
      //     SettableMetadata(contentType: 'image/jpeg'),
      //   )
      //       .whenComplete(() async {
      //     await _reference.getDownloadURL().then((value) {
      //       downloadUrl = value;
      //     });
      //   });
      //   return downloadUrl;
      // }
      // else {
      // Uint8List imageData = await XFile(file.path).readAsBytes();
      print(
          'The mime is ${lookupMimeType(file.path, headerBytes: await file.readAsBytes())}');
      final metadata = SettableMetadata(
        contentType:
            lookupMimeType(file.path, headerBytes: await file.readAsBytes()),
        customMetadata: {'picked-file-path': file.path},
      );
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = firebaseStorage
            .ref()
            .child(ref)
            .putData(await file.readAsBytes(), metadata);
      } else {
        uploadTask =
            firebaseStorage.ref().child(ref).putFile(File(file.path), metadata);
      }

      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
      // }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.message.toString());
      }
      return '';
    }
  }
}
