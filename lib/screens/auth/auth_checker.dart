import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippetphoneauth/models/user_model.dart';
import 'package:snippetphoneauth/screens/auth/login.dart';
import 'package:snippetphoneauth/screens/auth/providers/auth_provider.dart';
import 'package:snippetphoneauth/screens/home.dart';

// Auth status pengecekan
class AuthChecker extends StatelessWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, AuthProvider authProvider, __) {
      // Pengecekan variable auth status untuk menentukan route ke halaman
      if (authProvider.auth.currentUser != null) {
        return StreamProvider<UserModel>.value(
          value: AuthProvider().user,
          initialData: UserModel.initialData,
          child: const HomeScreen(),
        );
      } else {
        // masuk ke halaman login jika user auth tidak terisi
        return const LoginScreen();
      }
    });
  }
}
