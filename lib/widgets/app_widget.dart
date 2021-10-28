import 'package:flutter/material.dart';

class AppWidget {
  static loadingPageIndicator({
    required BuildContext context,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 100),
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.6),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (BuildContext context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: WillPopScope(
              onWillPop: () => Future.value(false),
              child: const Center(
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget loading sebelum menampilkan data
  static Widget loadingData({
    required String loadingTitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 35,
            width: 35,
            child: CircularProgressIndicator(),
          ),
          const SizedBox(height: 16),
          Text(loadingTitle)
        ],
      ),
    );
  }

  // Untuk manampilkan snackbar
  static showSnackBar({
    required BuildContext context,
    required Widget content,
    required Duration duration,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: content,
        duration: duration,
      ),
    );
  }
}
