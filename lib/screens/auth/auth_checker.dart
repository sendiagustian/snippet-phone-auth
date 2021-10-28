import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippetphoneauth/models/user_model.dart';
import 'package:snippetphoneauth/screens/auth/login.dart';
import 'package:snippetphoneauth/screens/auth/providers/auth_provider.dart';
import 'package:snippetphoneauth/screens/home.dart';
import 'package:snippetphoneauth/widgets/app_widget.dart';

// Auth status pengecekan
class AuthChecker extends StatelessWidget {
  static const String routeName = '/auth-checker';
  static const featureName = 'Auth Checker';

  const AuthChecker({Key? key}) : super(key: key);

  // Pembuatan widget untuk waiting screen
  Widget buildWaitingScreen() {
    return Scaffold(
      body: AppWidget.loadingData(loadingTitle: 'Mohon tunggu...'),
    );
  }

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
