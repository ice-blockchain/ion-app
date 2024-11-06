// SPDX-License-Identifier: ice License 1.0

class TrendingVideo {
  const TrendingVideo({
    required this.imageUrl,
    required this.authorName,
    required this.authorImageUrl,
    required this.likes,
    this.liked = false,
  });

  final String imageUrl;
  final String authorName;
  final String authorImageUrl;
  final int likes;
  final bool liked;
}
