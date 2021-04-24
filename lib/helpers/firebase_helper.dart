// ignore: avoid_web_libraries_in_flutter
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseHelper {
  static final FireBaseHelper _instace = FireBaseHelper.internal();
  User currentUser;

  factory FireBaseHelper() => _instace;

  FireBaseHelper.internal() {
    //escutar qualquer alteração
    FirebaseAuth.instance.authStateChanges().listen((user) {
      this.currentUser = user;
    });
  }

  Future<User> getUser() async {
    if (currentUser != null) return currentUser;
    //login com o google
    final GoogleSignIn googleSingin = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSingin.signIn();
    //login no firebass
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    //cria as credenciais
    final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    //faz login no firebase
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }

  Stream<QuerySnapshot> snapshots() {
    return FirebaseFirestore.instance
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future<void> sendMessage(String text) async {
    User user = await getUser();
    FirebaseFirestore.instance.collection("messages").add({
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotourl": user.photoURL,
      "text": text,
      "time": Timestamp.now()
    });
  }

/* mixin FirebaseStore {
  static var instance;
} */

  Future<void> sendImage(File file) async {
    // ignore: unused_local_variable
    User user = await getUser();
    StorageUploadTask task = FirebaseStorage.instance
        .ref()
        .child('imgs')
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putFile(file);

    StorageTaskSnapshot taskSnapshot = await task.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();

    FirebaseFirestore.instance
        .collection("messages")
        .add({"imgUrl": url, "time": Timestamp.now()});
  }
}
