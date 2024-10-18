// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/section_header/section_header.dart';
import 'package:ion/app/components/template/ice_component.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/features/dapps/views/components/featured_collection/featured_collection.dart';

class Featured extends IceComponent {
  const Featured({super.key});

  @override
  Widget buildComponent(BuildContext context, WidgetRef ref, int variant) {
    return Column(
      children: [
        SectionHeader(title: context.i18n.dapps_section_title_featured),
        const FeaturedCollection(),
      ],
    );
  }

  @override
  String get name => 'featured';
}
