import 'package:flutter/material.dart';

class DialogIndicatorProgress extends StatelessWidget {
  final String data;

  const DialogIndicatorProgress(this.data);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center),
    );
  }
}
