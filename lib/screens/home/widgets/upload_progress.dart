import 'package:flutter/material.dart';

class UploadProgress extends StatelessWidget {
  const UploadProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Uploading to Walrus...'),
      ],
    );
  }
}
