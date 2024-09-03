import 'dart:math';

class Story {
  const Story({
    required this.imageUrl,
    required this.author,
    this.nft = false,
    this.me = false,
  });

  final String imageUrl;
  final String author;
  final bool nft;
  final bool me;
}

final random = Random();

final List<Story> stories = [
  Story(
    author: 'you',
    imageUrl: 'https://i.pravatar.cc/150?u=@john',
    me: true,
    nft: random.nextBool(),
  ),
  Story(
    author: '@mysterox',
    imageUrl: 'https://i.pravatar.cc/150?u=@mysterox',
    nft: random.nextBool(),
  ),
  Story(
    author: '@foxydyrr',
    imageUrl: 'https://i.pravatar.cc/150?u=@foxydyrr',
    nft: random.nextBool(),
  ),
  Story(
    author: '@mikeydiy',
    imageUrl: 'https://i.pravatar.cc/150?u=@mikeydiy',
    nft: random.nextBool(),
  ),
  Story(
      author: '@isaiah ', imageUrl: 'https://i.pravatar.cc/150?u=@isaiah', nft: random.nextBool()),
  Story(
      author: '@kilback', imageUrl: 'https://i.pravatar.cc/150?u=@kilback', nft: random.nextBool()),
  Story(
      author: '@jamison', imageUrl: 'https://i.pravatar.cc/150?u=@jamison', nft: random.nextBool()),
  Story(
      author: '@rolfson', imageUrl: 'https://i.pravatar.cc/150?u=@rolfson', nft: random.nextBool()),
  Story(author: '@wendy', imageUrl: 'https://i.pravatar.cc/150?u=@wendy', nft: random.nextBool()),
  Story(
    author: '@cruickshank',
    imageUrl: 'https://i.pravatar.cc/150?u=@cruickshank',
    nft: random.nextBool(),
  ),
  Story(author: '@pierre', imageUrl: 'https://i.pravatar.cc/150?u=@pierre', nft: random.nextBool()),
  Story(
    author: '@armstrong',
    imageUrl: 'https://i.pravatar.cc/150?u=@armstrong',
    nft: random.nextBool(),
  ),
  Story(
      author: '@emanuel', imageUrl: 'https://i.pravatar.cc/150?u=@emanuel', nft: random.nextBool()),
  Story(author: '@kozey', imageUrl: 'https://i.pravatar.cc/150?u=@kozey', nft: random.nextBool()),
  Story(
      author: '@estella', imageUrl: 'https://i.pravatar.cc/150?u=@estella', nft: random.nextBool()),
  Story(author: '@ward', imageUrl: 'https://i.pravatar.cc/150?u=@ward', nft: random.nextBool()),
  Story(author: '@javier', imageUrl: 'https://i.pravatar.cc/150?u=@javier', nft: random.nextBool()),
  Story(
    author: '@bergnaum',
    imageUrl: 'https://i.pravatar.cc/150?u=@bergnaum',
    nft: random.nextBool(),
  ),
];
