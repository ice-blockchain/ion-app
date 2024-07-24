import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/model/video_data.dart';

class VideosFeedPage extends HookConsumerWidget {
  VideosFeedPage({
    super.key,
    required this.videos,
  });

  final List<VideoData> videos;
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageController pageController = usePageController(initialPage: 2);

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: colors.length,
        controller: pageController,
        itemBuilder: (context, index) {
          return Container(
            color: colors[index],
            child: Center(
              child: Text(
                'Page $index',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
