import 'dart:math';

import 'package:flutter/material.dart';

class Story {
  const Story({
    required this.imageUrl,
    required this.author,
    this.nft = false,
    this.me = false,
    this.gradientIndex = 0,
  });

  final String imageUrl;
  final String author;
  final bool nft;
  final bool me;
  final int gradientIndex;
}

final random = Random();

final List<Story> stories = [
  Story(
    author: 'you',
    imageUrl: 'https://i.pravatar.cc/150?u=@john',
    me: true,
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@mysterox',
    imageUrl: 'https://i.pravatar.cc/150?u=@mysterox',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@foxydyrr',
    imageUrl: 'https://i.pravatar.cc/150?u=@foxydyrr',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@mikeydiy',
    imageUrl: 'https://i.pravatar.cc/150?u=@mikeydiy',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@isaiah ',
    imageUrl: 'https://i.pravatar.cc/150?u=@isaiah',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@kilback',
    imageUrl: 'https://i.pravatar.cc/150?u=@kilback',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@jamison',
    imageUrl: 'https://i.pravatar.cc/150?u=@jamison',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@rolfson',
    imageUrl: 'https://i.pravatar.cc/150?u=@rolfson',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@wendy',
    imageUrl: 'https://i.pravatar.cc/150?u=@wendy',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@cruickshank',
    imageUrl: 'https://i.pravatar.cc/150?u=@cruickshank',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@pierre',
    imageUrl: 'https://i.pravatar.cc/150?u=@pierre',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@armstrong',
    imageUrl: 'https://i.pravatar.cc/150?u=@armstrong',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@emanuel',
    imageUrl: 'https://i.pravatar.cc/150?u=@emanuel',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@kozey',
    imageUrl: 'https://i.pravatar.cc/150?u=@kozey',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@estella',
    imageUrl: 'https://i.pravatar.cc/150?u=@estella',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@ward',
    imageUrl: 'https://i.pravatar.cc/150?u=@ward',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@javier',
    imageUrl: 'https://i.pravatar.cc/150?u=@javier',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
  Story(
    author: '@bergnaum',
    imageUrl: 'https://i.pravatar.cc/150?u=@bergnaum',
    nft: random.nextBool(),
    gradientIndex: Random().nextInt(storyBorderGradients.length),
  ),
];

final storyBorderGradients = [
  SweepGradient(
    colors: [
      Color(0xFFEF1D4F),
      Color(0xFFFF9F0E),
      Color(0xFFFFBB0E),
      Color(0xFFFF012F),
      Color(0xFFEF1D4F)
    ],
    stops: [0.0, 0.21, 0.47, 0.77, 1],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  SweepGradient(
    colors: [
      Color(0xFF0166FF),
      Color(0XFF00DDB5),
      Color(0XFF3800D6),
      Color(0XFF0166FF),
    ],
    stops: [0.0, 0.30, 0.72, 1],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  SweepGradient(
    colors: [
      Color(0xFFAE01FF),
      Color(0XFF1F00DD),
      Color(0XFF0AA7FF),
      Color(0XFFC100BA),
    ],
    stops: [0.0, 0.30, 0.72, 0.97],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  SweepGradient(
    colors: [
      Color(0xFF00AFA5),
      Color(0XFF1B76FF),
      Color(0XFF0AFFFF),
      Color(0XFF00C1B6),
    ],
    stops: [0.0, 0.30, 0.72, 0.97],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
];
