import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:snippetphoneauth/screens/auth/providers/auth_provider.dart';
import 'package:snippetphoneauth/widgets/app_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 40),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: const Text(
                    "Snippet Auth",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  "Masuk",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  "Silahkan masuk dengan nomor HP-mu",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 30),
                child: RichText(
                  text: const TextSpan(
                    text: 'Nomor HP',
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
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10, right: 16),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Consumer<AuthProvider>(
                        builder: (_, AuthProvider authProvider, __) {
                          return CountryListPick(
                            appBar: AppBar(
                              title: const Text('Pilih Kode Negara'),
                            ),
                            theme: CountryTheme(
                              isShowFlag: true,
                              isShowTitle: true,
                              isShowCode: true,
                              isDownIcon: true,
                              showEnglishName: false,
                            ),
                            initialSelection: authProvider.countryCode.dialCode,
                            onChanged: (CountryCode? code) {
                              authProvider.countryCode = code!;
                            },
                            pickerBuilder: (context, CountryCode? countryCode) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    countryCode!.dialCode!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 16),
                        child: Consumer<AuthProvider>(
                          builder: (_, AuthProvider authProvider, __) {
                            return Form(
                              child: TextFormField(
                                onChanged: (String text) {
                                  authProvider.notifyState();
                                },
                                onEditingComplete: () {
                                  if (authProvider.phoneNumberController.text
                                          .trim()[0] ==
                                      '0') {
                                    _onSubmit(
                                      context,
                                      '${authProvider.countryCode.dialCode!}${authProvider.phoneNumberController.text.trim().substring(1, authProvider.phoneNumberController.text.trim().length).trim()}',
                                    );
                                  } else {
                                    _onSubmit(
                                      context,
                                      '${authProvider.countryCode.dialCode!}${authProvider.phoneNumberController.text.trim()}',
                                    );
                                  }
                                },
                                keyboardType: TextInputType.phone,
                                controller: authProvider.phoneNumberController,
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: "8XX-XXXX-XXX",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      authProvider.phoneNumberController
                                          .clear();
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: Consumer<AuthProvider>(
          builder: (_, AuthProvider authProvider, __) {
            return FloatingActionButton(
              backgroundColor:
                  authProvider.phoneNumberController.text.length > 8
                      ? Colors.blue
                      : Colors.grey[400],
              onPressed: () {
                if (authProvider.phoneNumberController.text.trim()[0] == '0') {
                  _onSubmit(
                    context,
                    '${authProvider.countryCode.dialCode!}${authProvider.phoneNumberController.text.trim().substring(1, authProvider.phoneNumberController.text.trim().length).trim()}',
                  );
                } else {
                  _onSubmit(
                    context,
                    '${authProvider.countryCode.dialCode!}${authProvider.phoneNumberController.text.trim()}',
                  );
                }
              },
              child: const Icon(
                Icons.arrow_forward,
              ),
            );
          },
        ),
      ),
    );
  }

  // Fungsi onsubmit untuk menjalankan verifikasi phone dan melanjutkan ke verifi OTP
  Future<void> _onSubmit(
    BuildContext context,
    String phone,
  ) async {
    debugPrint('phone : $phone');
    if (phone.length > 8) {
      AppWidget.loadingPageIndicator(context: context);
      Provider.of<AuthProvider>(
        context,
        listen: false,
      ).verifyPhone(context, phone);
    }
  }
}
