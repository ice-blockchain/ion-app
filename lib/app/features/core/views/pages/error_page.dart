import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';

class ErrorPage extends IceSimplePage {
  const ErrorPage(super._route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    return const Scaffold(
      body: Center(
        child: Text('Oops'),
      ),
    );
  }
}
