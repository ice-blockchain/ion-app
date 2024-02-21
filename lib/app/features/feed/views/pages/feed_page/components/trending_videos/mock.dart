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

const List<TrendingVideo> trendingVideos = <TrendingVideo>[
  TrendingVideo(
    imageUrl:
        'https://loremflickr.com/cache/resized/65535_52849101574_4b6d732dc2_z_640_360_nofilter.jpg',
    authorName: '@john',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@john',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@mysteroxfoobarbaz',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@mysterox',
    likes: 14526,
    liked: true,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@foxydyrr',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@foxydyrr',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@mikeydiy',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@mikeydiy',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@isaiah ',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@isaiah',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@kilback',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@kilback',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@jamison',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@jamison',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@rolfson',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@rolfson',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@wendy',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@wendy',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@cruickshank',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@cruickshank',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@pierre',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@pierre',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@armstrong',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@armstrong',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@emanuel',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@emanuel',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@kozey',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@kozey',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@estella',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@estella',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@ward',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@ward',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@javier',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@javier',
    likes: 14526,
  ),
  TrendingVideo(
    imageUrl: 'https://picsum.photos/id/237/200/300',
    authorName: '@bergnaum',
    authorImageUrl: 'https://i.pravatar.cc/150?u=@bergnaum',
    likes: 14526,
  ),
];
