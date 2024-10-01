// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/section_header/section_header.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/dapps/views/components/categories_collection/categories_collection.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: context.i18n.dapps_section_title_categories),
        const CategoriesCollection(),
      ],
    );
  }
}
