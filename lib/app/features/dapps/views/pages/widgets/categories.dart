import 'package:flutter/material.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/categories_collection.dart';
import 'package:ice/app/shared/widgets/section_header/section_header.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        SectionHeader(title: 'Categories'),
        CategoriesCollection(),
      ],
    );
  }
}
