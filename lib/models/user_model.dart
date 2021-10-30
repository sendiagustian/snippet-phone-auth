import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late final String docUID;
  late final String phone;
  late final String status;
  late final DateTime? logedInDate;

  UserModel({
    required this.docUID,
    required this.phone,
    required this.status,
    this.logedInDate,
  });

  factory UserModel.fromData(DocumentSnapshot doc) {
    return UserModel(
      docUID: doc.id,
      phone: doc.get('phone'),
      status: doc.get('status'),
      logedInDate: doc.get('logedInDate').toDate(),
    );
  }

  Map<String, Object?> toData() {
    return {
      'docUID': docUID,
      'phone': phone,
      'status': status,
      'logedInDate': logedInDate,
    };
  }

  static UserModel get initialData {
    return UserModel(
      docUID: '',
      phone: '',
      status: '',
    );
  }
}
