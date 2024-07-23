import 'package:flutter/material.dart';

class AuthScrolledBody extends StatelessWidget {
  const AuthScrolledBody({
    super.key,
    required this.slivers,
    required this.controller,
  });

  final List<Widget> slivers;

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
        onNotification: (position) {
          controller.position.notifyListeners();
          return false;
        },
        child: CustomScrollView(
          controller: controller,
          slivers: slivers,
        ));
  }
}
