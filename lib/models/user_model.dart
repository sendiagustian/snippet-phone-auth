import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late final String docUID;
  late final String phone;
  late final String status;

  UserModel({
    required this.docUID,
    required this.phone,
    required this.status,
  });

  factory UserModel.fromData(DocumentSnapshot doc) {
    return UserModel(
      docUID: doc.id,
      phone: doc.get('phone'),
      status: doc.get('status'),
    );
  }

  static UserModel get initialData {
    return UserModel(
      docUID: '',
      phone: '',
      status: '',
    );
  }
}
