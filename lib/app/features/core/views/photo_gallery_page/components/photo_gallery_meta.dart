part of 'components.dart';

class PhotoGalleryMeta extends StatelessWidget {
  const PhotoGalleryMeta({
    required this.senderName,
    required this.sentAt,
    super.key,
  });

  final String senderName;
  final DateTime sentAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          senderName,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
        Text(
          formatMessageTimestamp(sentAt),
          style: context.theme.appTextThemes.caption2.copyWith(
            color: context.theme.appColors.onPrimaryAccent,
          ),
        ),
      ],
    );
  }
}
