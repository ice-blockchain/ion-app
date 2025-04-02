// SPDX-License-Identifier: ice License 1.0

part of '../url_preview_message.dart';

class _MetaDataPreview extends StatelessWidget {
  const _MetaDataPreview({
    required this.meta,
    required this.url,
    required this.favIconUrl,
    required this.isMe,
  });

  final OgpData meta;
  final String url;
  final String favIconUrl;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _SideVerticalDivider(isMe: isMe),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meta.image != null)
                  _MetaImage(
                    imageUrl: resolveImageUrl(url, meta.image!),
                  ),
                if (meta.siteName != null)
                  _MetaSiteInfo(meta.siteName!, favIconUrl: favIconUrl, isMe: isMe),
                if (meta.title != null) _MetaTitle(meta.title!, isMe: isMe),
                if (meta.description != null) _MetaDescription(meta.description!, isMe: isMe),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SideVerticalDivider extends StatelessWidget {
  const _SideVerticalDivider({
    required this.isMe,
  });

  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2.0.s,
      margin: EdgeInsetsDirectional.only(end: 8.0.s),
      decoration: BoxDecoration(
        color:
            isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryAccent,
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(2.0.s),
          bottomStart: Radius.circular(2.0.s),
        ),
      ),
    );
  }
}

class _MetaImage extends StatelessWidget {
  const _MetaImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 8.0.s),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0.s),
        child: IonNetworkImage(
          imageUrl: imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _MetaSiteInfo extends StatelessWidget {
  const _MetaSiteInfo(
    this.siteName, {
    required this.favIconUrl,
    required this.isMe,
  });

  final String siteName;
  final String favIconUrl;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 8.0.s),
      child: Row(
        children: [
          IonNetworkImage(
            imageUrl: favIconUrl,
            width: 16.0.s,
            height: 16.0.s,
            errorWidget: (context, url, error) => const SizedBox.shrink(),
          ),
          SizedBox(width: 6.0.s),
          Text(
            siteName,
            style: context.theme.appTextThemes.body2.copyWith(
              color: isMe
                  ? context.theme.appColors.onPrimaryAccent
                  : context.theme.appColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaTitle extends StatelessWidget {
  const _MetaTitle(this.title, {required this.isMe});

  final String title;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 2.0.s),
      child: Text(
        title,
        style: context.theme.appTextThemes.body2.copyWith(
          color:
              isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}

class _MetaDescription extends StatelessWidget {
  const _MetaDescription(this.description, {required this.isMe});

  final String description;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 2.0.s),
      child: Text(
        description,
        style: context.theme.appTextThemes.body2.copyWith(
          color:
              isMe ? context.theme.appColors.onPrimaryAccent : context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
