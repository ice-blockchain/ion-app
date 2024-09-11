import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class CreateStoryModal extends StatelessWidget {
  const CreateStoryModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.create_story_nav_title),
          ),
          Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
