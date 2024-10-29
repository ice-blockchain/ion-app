// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/create_story/data/models/story.dart';

final random = Random();

final List<Story> stories = [
  const Story.image(
    data: StoryData(
      id: '1',
      contentUrl: 'https://picsum.photos/500/800?random=1',
      imageUrl: 'https://i.pravatar.cc/150?u=@john_avatar',
      author: 'you',
      me: true,
      nft: true,
    ),
  ),
  Story.image(
    data: StoryData(
      id: '2',
      contentUrl: 'https://picsum.photos/500/800?random=2',
      imageUrl: 'https://i.pravatar.cc/150?u=@mysterox_avatar',
      author: '@mysterox',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.image(
    data: StoryData(
      id: '3',
      contentUrl: 'https://picsum.photos/500/800?random=3',
      imageUrl: 'https://i.pravatar.cc/150?u=@foxydyrr_avatar',
      author: '@foxydyrr',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.video(
    data: StoryData(
      id: '4',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_1.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@mikeydiy_avatar',
      author: '@mikeydiy',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
  Story.video(
    data: StoryData(
      id: '5',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_2.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@isaiah_avatar',
      author: '@isaiah',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
  Story.image(
    data: StoryData(
      id: '6',
      contentUrl: 'https://picsum.photos/500/800?random=6',
      imageUrl: 'https://i.pravatar.cc/150?u=@kilback_avatar',
      author: '@kilback',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.image(
    data: StoryData(
      id: '7',
      contentUrl: 'https://picsum.photos/500/800?random=7',
      imageUrl: 'https://i.pravatar.cc/150?u=@jamison_avatar',
      author: '@jamison',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.video(
    data: StoryData(
      id: '8',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_2.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@rolfson_avatar',
      author: '@rolfson',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
  Story.image(
    data: StoryData(
      id: '9',
      contentUrl: 'https://picsum.photos/500/800?random=9',
      imageUrl: 'https://i.pravatar.cc/150?u=@wendy_avatar',
      author: '@wendy',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.video(
    data: StoryData(
      id: '10',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_1.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@cruickshank_avatar',
      author: '@cruickshank',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
  Story.image(
    data: StoryData(
      id: '11',
      contentUrl: 'https://picsum.photos/500/800?random=11',
      imageUrl: 'https://i.pravatar.cc/150?u=@pierre_avatar',
      author: '@pierre',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.video(
    data: StoryData(
      id: '12',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_2.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@armstrong_avatar',
      author: '@armstrong',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
  Story.image(
    data: StoryData(
      id: '13',
      contentUrl: 'https://picsum.photos/500/800?random=13',
      imageUrl: 'https://i.pravatar.cc/150?u=@emanuel_avatar',
      author: '@emanuel',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.video(
    data: StoryData(
      id: '14',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_1.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@kozey_avatar',
      author: '@kozey',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
  Story.image(
    data: StoryData(
      id: '15',
      contentUrl: 'https://picsum.photos/500/800?random=15',
      imageUrl: 'https://i.pravatar.cc/150?u=@estella_avatar',
      author: '@estella',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.video(
    data: StoryData(
      id: '16',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_2.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@ward_avatar',
      author: '@ward',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
  Story.image(
    data: StoryData(
      id: '17',
      contentUrl: 'https://picsum.photos/500/800?random=17',
      imageUrl: 'https://i.pravatar.cc/150?u=@javier_avatar',
      author: '@javier',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
  ),
  Story.video(
    data: StoryData(
      id: '18',
      contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_1.mp4',
      imageUrl: 'https://i.pravatar.cc/150?u=@bergnaum_avatar',
      author: '@bergnaum',
      nft: random.nextBool(),
      gradientIndex: random.nextInt(storyBorderGradients.length),
    ),
    muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
  ),
];

final storyBorderGradients = [
  const SweepGradient(
    colors: [
      Color(0xFFEF1D4F),
      Color(0xFFFF9F0E),
      Color(0xFFFFBB0E),
      Color(0xFFFF012F),
      Color(0xFFEF1D4F),
    ],
    stops: [0.0, 0.21, 0.47, 0.77, 1],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  const SweepGradient(
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
  const SweepGradient(
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
  const SweepGradient(
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
