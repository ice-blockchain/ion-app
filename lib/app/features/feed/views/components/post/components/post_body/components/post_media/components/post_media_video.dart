import 'package:flutter/material.dart';

class PostMediaVideo extends StatelessWidget {
  const PostMediaVideo({required this.videoUrl, super.key});

  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Text('Video is not implemented yet'),
    );
  }
}
