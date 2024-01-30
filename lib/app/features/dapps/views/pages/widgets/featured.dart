import 'package:flutter/material.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_featured.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/featured_collection.dart';
import 'package:ice/app/shared/widgets/section_header/section_header.dart';

class Featured extends StatelessWidget {
  const Featured({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SectionHeader(title: 'Featured'),
        FeaturedCollection(items: featured),
      ],
    );
  }
}
