import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippetphoneauth/screens/auth/providers/auth_provider.dart';
import 'package:snippetphoneauth/widgets/app_widget.dart';

class VerificationScreen extends StatelessWidget {
  final String beUserPhone;

  const VerificationScreen({
    Key? key,
    required this.beUserPhone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 5, top: 48),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 15),
            child: const Text(
              "Kode OTP sudah di kirim!",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
            child: Text(
              "Masukkan kode OTP yang kami kirim ke nomor HP-mu, $beUserPhone.",
              maxLines: 3,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 30),
            child: RichText(
              text: const TextSpan(
                text: 'Kode OTP',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Form(
                    child: Container(
                      padding: const EdgeInsets.only(left: 0, right: 16),
                      child: Consumer<AuthProvider>(
                        builder: (_, AuthProvider authProvider, __) {
                          return TextFormField(
                            maxLength: 6,
                            onChanged: (String text) {
                              authProvider.notifyState();
                            },
                            onEditingComplete: () {
                              _onSubmit(
                                context,
                                beUserPhone,
                                authProvider.otpCodeController.text.trim(),
                              );
                            },
                            keyboardType: TextInputType.number,
                            controller: authProvider.otpCodeController,
                            decoration: InputDecoration(
                              counterText: '',
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: " •  •  •  •  •  •",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  authProvider.otpCodeController.clear();
                                },
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<AuthProvider>(
        builder: (_, AuthProvider authProvider, __) {
          return FloatingActionButton(
            backgroundColor: authProvider.otpCodeController.text.length > 5
                ? Colors.blue
                : Colors.grey[400],
            onPressed: () {
              _onSubmit(
                context,
                beUserPhone,
                authProvider.otpCodeController.text.trim(),
              );
            },
            child: const Icon(
              Icons.arrow_forward,
            ),
          );
        },
      ),
    );
  }

  // Fungsi onsubmit untuk menjalankan verifikasi OTP
  void _onSubmit(BuildContext context, String phone, String otpCode) {
    if (otpCode.length > 5) {
      // Memanggil fungsi verify otp number di auth provider
      Provider.of<AuthProvider>(context, listen: false).verifyOTP(
        context,
        phone,
        otpCode,
      );
    } else {
      AppWidget.showSnackBar(
        context: context,
        content: const Text('Kode OTP yang dimasukkan kurang.'),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
