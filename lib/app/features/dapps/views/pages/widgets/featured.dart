import 'package:flutter/material.dart';
import 'package:ice/app/shared/widgets/section_header/section_header.dart';

class Featured extends StatelessWidget {
  const Featured({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[SectionHeader(title: 'Featured')],
    );
  }
}
