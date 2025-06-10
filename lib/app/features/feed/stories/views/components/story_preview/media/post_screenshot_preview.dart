// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class PostScreenshotPreview extends StatelessWidget {
  const PostScreenshotPreview({
    required this.path,
    super.key,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: ColoredBox(
          color: colors.attentionBlock,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.s),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0.s),
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
