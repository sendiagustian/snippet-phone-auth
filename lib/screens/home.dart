import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippetphoneauth/screens/auth/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snippet Phone Auth'),
        actions: [
          Consumer<AuthProvider>(
            builder: (_, authProvider, __) {
              return IconButton(
                onPressed: () {
                  authProvider.logOut(context);
                },
                icon: const Icon(
                  Icons.logout,
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
