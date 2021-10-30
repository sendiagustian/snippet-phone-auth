import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snippetphoneauth/databases/snippet_auth_database.dart';
import 'package:snippetphoneauth/models/user_model.dart';
import 'package:snippetphoneauth/screens/auth/auth_checker.dart';
import 'package:snippetphoneauth/screens/auth/verification.dart';
import 'package:snippetphoneauth/widgets/app_widget.dart';

// Provider untuk halaman auth
class AuthProvider with ChangeNotifier {
  // Pendekralasian/inisiasi object auth firebase
  FirebaseAuth auth = FirebaseAuth.instance;

  // Pendekralasian/inisiasi object firebase firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Deklarasi variabel Varification Id untuk auth
  String? verificationId;

  // Deklarasi variabel country code untuk menyimpan code
  CountryCode _countryCode = CountryCode(dialCode: '+62');

  // Deklarasi variabel _phoneNumberController, untuk Controller TextField
  TextEditingController _phoneNumberController = TextEditingController();

  // getter untuk menampilkan var _phoneNumberController
  TextEditingController get phoneNumberController => _phoneNumberController;

  // Setter untuk mengubah controller textfield _phoneNumberController
  set phoneNumberController(TextEditingController phoneNumberController) {
    _phoneNumberController = phoneNumberController;
    notifyListeners();
  }

  // Deklarasi variabel  _otpCodeController, untuk Controller TextField
  TextEditingController _otpCodeController = TextEditingController();

  // getter untuk menampilkan var _otpCodeController
  TextEditingController get otpCodeController => _otpCodeController;

  // Setter untuk mengubah controller textfield _otpCodeController
  set otpCodeController(TextEditingController otpCodeController) {
    _otpCodeController = otpCodeController;
    notifyListeners();
  }

  // getter untuk menampilkan countryCode
  CountryCode get countryCode => _countryCode;

  // Setter untuk mengubah countrycode
  set countryCode(CountryCode countryCode) {
    _countryCode = countryCode;
    notifyListeners();
  }

  // Fungsi stream get data user ke collection yang dijalankan oleh StremProvider
  Stream<UserModel>? get user {
    // pengecekan user login auth
    if (auth.currentUser != null) {
      // Nilai dikembalikan untuk mengupdate data model user data
      return firestore
          .collection('snippet-phone-auth')
          .doc(auth.currentUser!.uid)
          .snapshots()
          .map((userModel) {
        return UserModel.fromData(userModel);
      });
    } else {
      // Nilai dikembalikan null jika user belum login auth
      return null;
    }
  }

  // Fungsi untuk verifikasi nomber hp agar mendapatkan OTP
  Future<void> verifyPhone(
    BuildContext context,
    String phoneToSend,
  ) async {
    try {
      // ignore: prefer_function_declarations_over_variables
      final PhoneCodeSent smsOTPSent = (String verId, int? forceCodeResend) {
        verificationId = verId;
      };

      // Fungsi bawaan auth_firebase untuk verifikasi nomor telpon
      await auth.verifyPhoneNumber(
          // Nomber yang ingin di verifikasi
          phoneNumber: phoneToSend,
          // CodeSent
          codeSent: smsOTPSent,
          // Waktu timeout fungsi
          timeout: const Duration(seconds: 10),

          // Mengirim SMS dengan kode 6 digit ke nomor telepon yang ditentukan, atau memasukkan pengguna dan [verifikasiCompleted] dipanggil.
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
            if (verificationId != null) {
              notifyListeners();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return VerificationScreen(
                      beUserPhone: phoneToSend,
                    );
                  },
                ),
              );
            } else {
              Navigator.of(context).pop();
              notifyListeners();
            }
          },
          // Memulai proses verifikasi nomor telepon untuk nomor telepon yang diberikan.
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            if (verificationId != null) {
              notifyListeners();
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return VerificationScreen(
                        beUserPhone: phoneToSend,
                      );
                    },
                  ),
                );
              });
            } else {
              Navigator.of(context).pop();
              notifyListeners();
            }
          },
          // Ketika verifikasi gagal
          verificationFailed: (FirebaseAuthException e) {
            Navigator.of(context).pop();
            if (e.code == 'invalid-phone-number') {
              debugPrint('Nomor yang dimasukan salah.');
              AppWidget.showSnackBar(
                context: context,
                content: const Text('Nomor yang anda masukan salah.'),
                duration: const Duration(seconds: 3),
              );
            } else if (e.code == 'too-many-requests') {
              debugPrint('Terlalu banyak request');

              AppWidget.showSnackBar(
                context: context,
                content: const Text(
                  'Anda terlalu sering request OTP, tunggu beberapa saat lalu coba lagi.',
                ),
                duration: const Duration(seconds: 3),
              );
            } else {
              debugPrint('Error Message : $e');
            }
          });
    } catch (e) {
      Navigator.of(context).pop();
      debugPrint('Catch Error Message : $e');
    }
  }

  // Fungsi untuk verifikasi kode OTP
  Future<void> verifyOTP(BuildContext context, String phone, String otp) async {
    AppWidget.loadingPageIndicator(context: context);
    phoneNumberController.clear();
    otpCodeController.clear();
    AuthCredential credential;
    UserCredential authLogin;
    User? currentUser;
    try {
      // Dari verify id dan otp code di simpan dalam credential
      credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );
      // Lakukan login dengan credential lalu simpan ke dalam User Credential
      authLogin = await auth.signInWithCredential(
        credential,
      );
      // Simpan User Credential ke dalam model user auth untuk di gunakan
      currentUser = authLogin.user;
    } catch (e) {
      debugPrint('$e');
      if (e.toString().contains("firebase_auth/invalid-verification-code")) {
        AppWidget.showSnackBar(
          context: context,
          content: const Text(
              'Kode OTP salah, silahkan coba kirim ulang kode dan coba lagi.'),
          duration: const Duration(seconds: 3),
        );
      }
    }
    // Lakukan pengecekan untuk melanjutkan ke home jika user auth sudah terisi
    if (currentUser != null) {
      await PhoneAuthDatabase()
          .getUserData(currentUser.uid)
          .then((userDataDoc) async {
        final UserModel userModel = UserModel(
          docUID: currentUser!.uid,
          phone: phone,
          status: 'active',
          logedInDate: DateTime.now(),
        );
        if (userDataDoc.exists) {
          await PhoneAuthDatabase().updateDataUser(
            currentUser.uid,
            data: {
              'logedInDate': DateTime.now(),
            },
          );
        } else {
          await PhoneAuthDatabase().createUser(userModel);
        }
      });
      // Jika auth login telah terisi maka alihkan kembali ke halaman auth checker
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) {
            return const AuthChecker();
          },
        ),
      );
    }
    // Jika user auth tidak terisi maka jangan lanjutkan ke home
    else {
      Navigator.of(context).pop();
      notifyListeners();
    }
  }

  // Fungsi untuk log out
  Future<String> logOut(BuildContext context) async {
    AppWidget.loadingPageIndicator(context: context);
    // Destroy isi model user auth (untuk menandakan bahwa user telah logout)
    await auth.signOut();
    // Navigasi ke halaman pengecekan
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) {
          return const AuthChecker();
        },
      ),
    );
    notifyListeners();
    return 'logout';
  }

  // Untuk notis state kosong
  void notifyState() {
    notifyListeners();
  }
}
