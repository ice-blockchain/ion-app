import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/features/dapps/views/components/categories_collection/categories_collection.dart';
import 'package:ice/app/features/dapps/views/components/section_header/section_header.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionHeader(title: context.i18n.dapps_section_title_categories),
        const CategoriesCollection(),
      ],
    );
  }
}
