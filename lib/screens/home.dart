import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippetphoneauth/models/user_model.dart';
import 'package:snippetphoneauth/screens/auth/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(userModel.docUID),
          Text(userModel.phone),
          Text(userModel.status),
          Text(userModel.logedInDate.toString()),
          const Text('Home Screen'),
        ],
      ),
    );
  }
}
