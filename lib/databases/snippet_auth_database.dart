import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snippetphoneauth/models/user_model.dart';

class PhoneAuthDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String collectionName = 'snippet-phone-auth';

  // Get user data
  Future<DocumentSnapshot> getUserData(String uid) async {
    return await firestore.collection(collectionName).doc(uid).get();
  }

  // Create new user
  Future createUser(UserModel userModel) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(userModel.docUID)
          .set(userModel.toData());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Update data user
  Future updateDataUser(String uid, {required var data}) async {
    try {
      await firestore.collection(collectionName).doc(uid).update(data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
