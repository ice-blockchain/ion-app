// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.error, super.key});

  final Exception error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Oops: $error'),
      ),
    );
  }
}
