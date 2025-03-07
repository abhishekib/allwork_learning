import 'package:flutter/material.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No Internet Connection'),
      content: Text('Please check your internet connection and try again.'),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
