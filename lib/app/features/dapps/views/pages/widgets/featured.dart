import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_featured.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/featured_collection.dart';
import 'package:ice/app/shared/widgets/section_header/section_header.dart';
import 'package:ice/app/shared/widgets/template/ice_control.dart';

class Featured extends IceControl {
  const Featured({super.key});

  @override
  Widget buildControl(BuildContext context, WidgetRef ref, int variant) {
    return Column(
      children: <Widget>[
        const SectionHeader(title: 'Featured'),
        FeaturedCollection(items: featured),
      ],
    );
  }

  @override
  String get name => 'featured';
}
