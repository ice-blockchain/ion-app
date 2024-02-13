import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/dapps/views/components/featured_collection.dart';
import 'package:ice/app/features/dapps/views/components/section_header/section_header.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_featured.dart';
import 'package:ice/app/shared/widgets/template/ice_control.dart';

class Featured extends IceControl {
  const Featured({super.key});

  @override
  Widget buildControl(BuildContext context, WidgetRef ref, int variant) {
    return Column(
      children: <Widget>[
        SectionHeader(title: context.i18n.dapps_section_title_featured),
        FeaturedCollection(items: featured),
      ],
    );
  }

  @override
  String get name => 'featured';
}
