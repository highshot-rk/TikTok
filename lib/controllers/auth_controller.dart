import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:tiktok/constants.dart';
import 'package:tiktok/models/user.dart' as model;

class Authcontroller extends GetxController {

  static Authcontroller instance = Get.find();

  late Rx<File?> _pickedImage;
  File? get profilePhoto => _pickedImage.value;

  void pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null) {
      Get.snackbar('Profile Picture', 'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
  }
  
  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage.ref().child('profilePics').child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
  // register user
  void registerUser(String username, String email, String password, File? image) async {
    try {
      if(username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(email: email, name: username, uid: cred.user!.uid, profilePhoto: downloadUrl);
        await firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      } else {
        Get.snackbar('Error Creating Account','Please enter all the fields');
      }
    // ignore: empty_catches
    } catch (e) {
      Get.snackbar('Error Creating Account', e.toString());
    }
  }

  // login user
  void loginUser(String email, String password) async {
    try {
      if(email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        print('Login success');
      } else {
        Get.snackbar('Error Login Account','Please enter all the fields');
      }
    } catch(e) {
      Get.snackbar('Error Login Account', e.toString());
    }
  }
}