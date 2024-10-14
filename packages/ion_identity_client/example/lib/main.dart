// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ion_client_example/pages/users/users_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: IonClientExample(),
    ),
  );
}

class IonClientExample extends StatelessWidget {
  const IonClientExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ion Identity Client Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UsersPage(),
    );
  }
}
