// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticleImageView extends StatelessWidget {
  const ArticleImageView({
    required this.selectedImage,
    required this.onClearImage,
    super.key,
  });

  final MediaFile selectedImage;
  final VoidCallback onClearImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            File(selectedImage.path),
            fit: BoxFit.cover,
          ),
        ),
        PositionedDirectional(
          top: 12.0.s,
          end: 12.0.s,
          child: IconButton(
            onPressed: onClearImage,
            icon: Assets.svg.iconFieldClearall.icon(size: 20.0.s),
          ),
        ),
      ],
    );
  }
}
