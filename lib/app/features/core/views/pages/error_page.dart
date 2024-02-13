import 'package:flutter/material.dart';
import 'package:ice/app/shared/widgets/template/ice_page.dart';

class ErrorPage extends IceSimplePage {
  const ErrorPage(super._route, super.payload);

  @override
  Widget buildPage(_, __, ____) {
    return const Scaffold(
      body: Center(
        child: Text('Oops'),
      ),
    );
  }
}
