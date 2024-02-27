class Story {
  const Story({
    required this.imageUrl,
    required this.author,
    this.me = false,
  });

  final String imageUrl;
  final String author;
  final bool me;
}

const List<Story> stories = <Story>[
  Story(
    author: '@john',
    imageUrl: 'https://i.pravatar.cc/150?u=@john',
    me: true,
  ),
  Story(author: '@mysterox', imageUrl: 'https://i.pravatar.cc/150?u=@mysterox'),
  Story(author: '@foxydyrr', imageUrl: 'https://i.pravatar.cc/150?u=@foxydyrr'),
  Story(author: '@mikeydiy', imageUrl: 'https://i.pravatar.cc/150?u=@mikeydiy'),
  Story(author: '@isaiah ', imageUrl: 'https://i.pravatar.cc/150?u=@isaiah'),
  Story(author: '@kilback', imageUrl: 'https://i.pravatar.cc/150?u=@kilback'),
  Story(author: '@jamison', imageUrl: 'https://i.pravatar.cc/150?u=@jamison'),
  Story(author: '@rolfson', imageUrl: 'https://i.pravatar.cc/150?u=@rolfson'),
  Story(author: '@wendy', imageUrl: 'https://i.pravatar.cc/150?u=@wendy'),
  Story(
    author: '@cruickshank',
    imageUrl: 'https://i.pravatar.cc/150?u=@cruickshank',
  ),
  Story(author: '@pierre', imageUrl: 'https://i.pravatar.cc/150?u=@pierre'),
  Story(
    author: '@armstrong',
    imageUrl: 'https://i.pravatar.cc/150?u=@armstrong',
  ),
  Story(author: '@emanuel', imageUrl: 'https://i.pravatar.cc/150?u=@emanuel'),
  Story(author: '@kozey', imageUrl: 'https://i.pravatar.cc/150?u=@kozey'),
  Story(author: '@estella', imageUrl: 'https://i.pravatar.cc/150?u=@estella'),
  Story(author: '@ward', imageUrl: 'https://i.pravatar.cc/150?u=@ward'),
  Story(author: '@javier', imageUrl: 'https://i.pravatar.cc/150?u=@javier'),
  Story(author: '@bergnaum', imageUrl: 'https://i.pravatar.cc/150?u=@bergnaum'),
];
