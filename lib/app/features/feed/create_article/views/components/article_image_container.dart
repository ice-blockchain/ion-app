// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/views/components/article_image_view.dart';
import 'package:ion/app/features/feed/create_article/views/components/article_placeholder.dart';
import 'package:ion/app/features/feed/views/components/article/constants.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticleImageContainer extends StatelessWidget {
  const ArticleImageContainer({
    required this.selectedImage,
    required this.onPressed,
    required this.onClearImage,
    this.selectedImageUrl,
    super.key,
  });

  final MediaFile? selectedImage;
  final String? selectedImageUrl;
  final VoidCallback? onPressed;
  final VoidCallback onClearImage;

  @override
  Widget build(BuildContext context) {
    final hasImage = selectedImage != null || selectedImageUrl != null;

    return GestureDetector(
      onTap: hasImage ? null : onPressed,
      child: ScreenSideOffset.small(
        child: AspectRatio(
          aspectRatio: ArticleConstants.headerImageAspectRation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0.s),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SvgPicture.asset(
                  Assets.svg.articlePlaceholder,
                  fit: BoxFit.cover,
                ),
                if (hasImage)
                  ArticleImageView(
                    selectedImage: selectedImage,
                    imageUrl: selectedImageUrl,
                    onClearImage: onClearImage,
                  )
                else
                  const ArticlePlaceholder(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
