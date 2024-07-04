import 'package:flutter/material.dart';

class PostMediaVideo extends StatelessWidget {
  const PostMediaVideo({required this.imageUrl, super.key});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Placeholder(
        child: Text('Video is not implemented yet'),
      ),
    );
  }
}
