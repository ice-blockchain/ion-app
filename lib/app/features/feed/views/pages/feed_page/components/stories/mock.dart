// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';

final random = Random();

// final List<Story> stories = [
//   const Story.image(
//     data: StoryData(
//       id: '1',
//       authorId: 'john',
//       author: 'you',
//       contentUrl: 'https://picsum.photos/500/800?random=1',
//       imageUrl: 'https://i.pravatar.cc/150?u=@john_avatar',
//       me: true,
//       nft: true,
//     ),
//   ),
//   Story.image(
//     data: StoryData(
//       id: '2',
//       authorId: 'mysterox',
//       author: '@mysterox',
//       contentUrl: 'https://picsum.photos/500/800?random=2',
//       imageUrl: 'https://i.pravatar.cc/150?u=@mysterox_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//   ),
//   Story.image(
//     data: StoryData(
//       id: '3',
//       authorId: 'isaiah',
//       author: '@isaiah',
//       contentUrl: 'https://picsum.photos/500/800?random=3',
//       imageUrl: 'https://i.pravatar.cc/150?u=@isaiah_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//   ),
//   Story.video(
//     data: StoryData(
//       id: '4',
//       authorId: 'isaiah',
//       author: '@isaiah',
//       contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_1.mp4',
//       imageUrl: 'https://i.pravatar.cc/150?u=@isaiah_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//     muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
//   ),
//   Story.video(
//     data: StoryData(
//       id: '5',
//       authorId: 'jamison',
//       author: '@jamison',
//       contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_2.mp4',
//       imageUrl: 'https://i.pravatar.cc/150?u=@jamison_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//     muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
//   ),
//   Story.image(
//     data: StoryData(
//       id: '6',
//       authorId: 'jamison',
//       author: '@jamison',
//       contentUrl: 'https://picsum.photos/500/800?random=6',
//       imageUrl: 'https://i.pravatar.cc/150?u=@jamison_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//   ),
//   Story.image(
//     data: StoryData(
//       id: '7',
//       authorId: 'wendy',
//       author: '@wendy',
//       contentUrl: 'https://picsum.photos/500/800?random=7',
//       imageUrl: 'https://i.pravatar.cc/150?u=@wendy_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//   ),
//   Story.video(
//     data: StoryData(
//       id: '8',
//       authorId: 'wendy',
//       author: '@wendy',
//       contentUrl: 'https://www.exit109.com/~dnn/clips/RW20seconds_2.mp4',
//       imageUrl: 'https://i.pravatar.cc/150?u=@wendy_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//     muteState: random.nextBool() ? MuteState.muted : MuteState.unmuted,
//   ),
//   Story.image(
//     data: StoryData(
//       id: '9',
//       authorId: 'wendy',
//       author: '@wendy',
//       contentUrl: 'https://picsum.photos/500/800?random=9',
//       imageUrl: 'https://i.pravatar.cc/150?u=@wendy_avatar',
//       nft: random.nextBool(),
//       gradientIndex: random.nextInt(storyBorderGradients.length),
//     ),
//   ),
// ];

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
