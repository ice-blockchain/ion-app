import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/dapps/views/components/featured_collection.dart';
import 'package:ice/app/features/dapps/views/components/section_header/section_header.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_featured.dart';

class Featured extends StatelessWidget {
  const Featured({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionHeader(title: context.i18n.dapps_section_title_featured),
        FeaturedCollection(items: featured),
      ],
    );
  }
}
