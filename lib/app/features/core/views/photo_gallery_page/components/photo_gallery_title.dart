// SPDX-License-Identifier: ice License 1.0

part of 'components.dart';

class PhotoGalleryTitle extends StatelessWidget {
  const PhotoGalleryTitle({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.onPrimaryAccent,
      ),
    );
  }
}
