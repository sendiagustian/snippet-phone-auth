import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippetphoneauth/screens/auth/auth_checker.dart';
import 'package:snippetphoneauth/screens/auth/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Snippet Phone Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthChecker(),
      ),
    );
  }
}
