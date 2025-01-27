// SPDX-License-Identifier: ice License 1.0

part of '../url_preview_content.dart';

class _UrlMetadataPreview extends StatelessWidget {
  const _UrlMetadataPreview({
    required this.meta,
    required this.url,
    required this.favIconUrl,
  });

  final OgpData meta;
  final String url;
  final String favIconUrl;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.0.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meta.image != null)
              _UrlMetadataImage(
                imageUrl: resolveImageUrl(url, meta.image!),
              ),
            if (meta.siteName != null) _UrlMetadataSiteInfo(meta.siteName!, favIconUrl: favIconUrl),
            if (meta.title != null) _UrlMetadataTitle(meta.title!),
            if (meta.description != null) _UrlMetadataDescription(meta.description!),
          ],
        ),
      ),
    );
  }
}

class _UrlMetadataImage extends StatelessWidget {
  const _UrlMetadataImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0.s),
        topRight: Radius.circular(12.0.s),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const SizedBox.shrink(),
      ),
    );
  }
}

class _UrlMetadataSiteInfo extends StatelessWidget {
  const _UrlMetadataSiteInfo(
    this.siteName, {
    required this.favIconUrl,
  });

  final String siteName;
  final String favIconUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.s, right: 12.0.s, top: 12.0.s),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: favIconUrl,
            imageBuilder: (context, imageProvider) => Row(
              children: [
                Image(
                  image: imageProvider,
                  width: 13.0.s,
                  height: 13.0.s,
                ),
                SizedBox(width: 6.0.s),
              ],
            ),
            errorWidget: (_, __, ___) => const SizedBox.shrink(),
          ),
          Text(
            siteName,
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.quaternaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _UrlMetadataTitle extends StatelessWidget {
  const _UrlMetadataTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.0.s, left: 12.0.s, right: 12.0.s),
      child: Text(
        title,
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}

class _UrlMetadataDescription extends StatelessWidget {
  const _UrlMetadataDescription(this.description);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 4.0.s,
        left: 12.0.s,
        right: 12.0.s,
      ),
      child: Text(
        description,
        style: context.theme.appTextThemes.caption2.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
      ),
    );
  }
}

String resolveImageUrl(String baseUrl, String imageUrl) {
  return imageUrl.startsWith('/')
      ? Uri.parse(Uri.parse(baseUrl).origin + imageUrl).toString()
      : imageUrl;
}
