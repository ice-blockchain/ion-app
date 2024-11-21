// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/services/media_service/media_service.dart';

class CreateVideoModal extends StatelessWidget {
  const CreateVideoModal({
    this.mediaFiles = const [],
    super.key,
  });

  final List<MediaFile> mediaFiles;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.common_add_video),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
