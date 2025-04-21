// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.message,
    super.key,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    final errorMessage = message ?? 'Unknown error';

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Oops: $errorMessage'),
        ),
      ),
    );
  }
}
