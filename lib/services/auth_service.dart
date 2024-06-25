import 'dart:convert';
import 'dart:io';

import 'package:chatappp_socketio/models/user_model.dart' as usermodel;
import 'package:chatappp_socketio/services/user_provider.dart';
import 'package:chatappp_socketio/utils/error_handler.dart';
import 'package:chatappp_socketio/utils/otpdialog.dart';
import 'package:chatappp_socketio/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AuthMethods {
  late final FirebaseAuth _auth;
  AuthMethods(
    this._auth,
  );

  User get user => _auth.currentUser!;
  String _uri = 'http://localhost:8080';

  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  Future<void> phoneSignIn(BuildContext context,
      {required String phoneNumber}) async {
    TextEditingController codeController = TextEditingController();
    await getUser(context: context, phoneNumber: phoneNumber).then((val) async {
      if (val) {
        if (kIsWeb) {
          try {
            print('its in kIsWeb');
            ConfirmationResult confirmationResult =
                await _auth.signInWithPhoneNumber(phoneNumber);
            if (context.mounted) {
              showOTPDialog(
                  context: context,
                  codeController: codeController,
                  onPressed: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: confirmationResult.verificationId,
                            smsCode: codeController.text.trim());
                    try {
                      await getUser(context: context, phoneNumber: phoneNumber)
                          .then((val) async {
                        if (val) {
                          await _auth.signInWithCredential(credential);
                          if (context.mounted) {
                            Navigator.pop(context);
                            showSnackBar(context, "User Loggedin Sucessfully");
                          }
                        }
                      });
                    } on FirebaseAuthException catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        showSnackBar(context, e.message.toString());
                      }
                    }
                  });
            }
            //  return true;
          } on FirebaseAuthException catch (e) {
            if (context.mounted) {
              showSnackBar(
                  context, 'snackbar error msg :${e.message.toString()}');
            }
          }
        } else {
          try {
            await _auth.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              verificationCompleted: (PhoneAuthCredential credential) async {
                await _auth.signInWithCredential(credential);
              },
              verificationFailed: (e) {
                showSnackBar(context, e.message.toString());
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
              codeSent:
                  (String verificationId, int? forceResendingToken) async {
                showOTPDialog(
                    context: context,
                    codeController: codeController,
                    onPressed: () async {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: codeController.text.trim());

                      try {
                        await getUser(
                                context: context, phoneNumber: phoneNumber)
                            .then((val) async {
                          if (val) {
                            await _auth.signInWithCredential(credential);
                            if (context.mounted) {
                              Navigator.pop(context);
                              showSnackBar(
                                  context, "User Loggedin Sucessfully");
                            }
                          }
                        });
                      } on FirebaseAuthException catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          showSnackBar(context, e.message.toString());
                        }
                      }
                    });
                // notifyListeners();
              },
            );
          } on FirebaseAuthException catch (e) {
            if (context.mounted) {
              Navigator.pop(context);
              showSnackBar(context, e.message.toString());
            }
          }
        }
      } else {
        showSnackBar(context, "User doesn't exist,Please SignUp");
      }
    });
  }

  Future<void> phoneSignUp(BuildContext context,
      {required String username,
      required String phoneNumber,
      required File? profilePic}) async {
    TextEditingController codeController = TextEditingController();

    if (kIsWeb) {
      try {
        print('its in kIsWeb');
        ConfirmationResult confirmationResult =
            await _auth.signInWithPhoneNumber(phoneNumber);
        if (context.mounted) {
          showOTPDialog(
              context: context,
              codeController: codeController,
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: confirmationResult.verificationId,
                    smsCode: codeController.text.trim());
                try {
                  await _auth
                      .signInWithCredential(credential)
                      .then((value) async => {
                            await storeFileToFirebase(
                                    "profilePic/${user.uid}", profilePic!)
                                .then((url) {
                              createUser(
                                  context: context,
                                  username: username,
                                  phoneNumber: phoneNumber,
                                  uid: value.user!.uid,
                                  url: url);
                            })
                          });
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } on FirebaseAuthException catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    showSnackBar(context, e.message.toString());
                  }
                }
              });
        }
        //  return true;
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          showSnackBar(context, 'snackbar error msg :${e.message.toString()}');
        }
      }
    } else {
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            showSnackBar(context, e.message.toString());
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          codeSent: (String verificationId, int? forceResendingToken) async {
            showOTPDialog(
                context: context,
                codeController: codeController,
                onPressed: () async {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: codeController.text.trim());

                  try {
                    await _auth
                        .signInWithCredential(credential)
                        .then((value) async => {
                              await storeFileToFirebase(
                                      "profilePic/${user.uid}", profilePic!)
                                  .then((url) {
                                createUser(
                                    context: context,
                                    username: username,
                                    phoneNumber: phoneNumber,
                                    uid: value.user!.uid,
                                    url: url);
                              })
                            });
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      showSnackBar(context, e.message.toString());
                    }
                  }
                });
            // notifyListeners();
          },
        );
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          showSnackBar(context, e.message.toString());
        }
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createUser(
      {required BuildContext context,
      required String username,
      required String phoneNumber,
      required String uid,
      required String? url}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${_uri}/api/create-user'),
        body: jsonEncode({
          'user': {
            'username': username,
            'phoneNumber': phoneNumber,
            'uid': uid,
            "profilePic":
                usermodel.ProfilePic(url: url ?? '', localPath: '').toMap(),
          }
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      var response = jsonDecode(res.body);

      usermodel.User updatedUser = usermodel.User.fromMap(response['user']);

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            print('USER CREATED SUCCESSFULLY');

            Provider.of<UserProvider>(context, listen: false)
                .updateUser(updatedUser);

            showSnackBar(context, response['msg']);
          },
        );
      }
    } catch (e) {
      print('THE USER CREATION ERROR is ${e.toString()}');
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  Future<bool> getUser(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${_uri}/api/get-user'),
        body: jsonEncode({
          'user': {
            'phoneNumber': phoneNumber,
          }
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      var response = jsonDecode(res.body);
      bool isUserExist = response['isUserExist'] as bool;
      if (isUserExist) {
        usermodel.User updatedUser = usermodel.User.fromMap(response['user']);
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .updateUser(updatedUser);
        }
      }

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            // print('GET-USER res: ${response['msg']}');
            // showSnackBar(context, response['msg']);
          },
        );
        return isUserExist;
      }
      return isUserExist;
    } catch (e) {
      print('THE USER CREATION ERROR is ${e.toString()}');
      if (context.mounted) {
        showSnackBar(context, e.toString());
        return false;
      }
      return false;
    }
  }

  Future<bool> updateProfilePic(
      {required BuildContext context, required File file}) async {
    try {
      String url = await storeFileToFirebase("profilePic/${user.uid}", file);
      print("The profilePic url is ${url}");

      http.Response res = await http.post(
        Uri.parse('${_uri}/api/update-profilePic'),
        body: jsonEncode({
          'user': {'url': url, 'uid': user.uid}
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      var response = jsonDecode(res.body);

      bool updated = response['updated'] as bool;
      if (updated) {
        usermodel.User updatedUser = usermodel.User.fromMap(response['user']);
        if (context.mounted) {
          Provider.of<UserProvider>(context, listen: false)
              .updateUser(updatedUser);
        }
      }

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            // print('GET-USER res: ${response['msg']}');
            // showSnackBar(context, response['msg']);
          },
        );
        return updated;
      }
      return updated;
    } catch (e) {
      print('THE USER CREATION ERROR is ${e.toString()}');
      if (context.mounted) {
        showSnackBar(context, e.toString());
        return false;
      }
      return false;
    }
  }

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
