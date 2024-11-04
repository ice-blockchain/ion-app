// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

class ImageStoryViewer extends StatelessWidget {
  const ImageStoryViewer({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      path,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
