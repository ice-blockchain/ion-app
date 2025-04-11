// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/new_bookmarks_collection_button.dart';
import 'package:ion/app/features/feed/views/pages/add_bookmark_modal/compoents/all_bookmarks_tile.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class AddBookmarkModal extends StatelessWidget {
  const AddBookmarkModal({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: SingleChildScrollView(
        child: ScreenSideOffset.small(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  bottom: 16.0.s,
                  top: 24.0.s,
                ),
                child: AllBookmarksTile(eventReference: eventReference),
              ),
              const HorizontalSeparator(),
              const NewBookmarksCollectionButton(),
              SizedBox(height: 16.0.s),
            ],
          ),
        ),
      ),
    );
  }
}
