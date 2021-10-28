import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneAuthDatabase {
  final String? docId;
  PhoneAuthDatabase({this.docId});

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String collectionName = 'snippet-phone-auth';
}
