// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/back_hardware_button_interceptor/back_hardware_button_interceptor.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/create_post_app_bar.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/create_post_bottom_panel.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/create_post_content.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/hooks/use_post_quill_controller.dart';
import 'package:ion/app/features/feed/views/pages/cancel_creation_modal/cancel_creation_modal.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class CreatePostModal extends HookConsumerWidget {
  const CreatePostModal({
    super.key,
    this.parentEvent,
    this.quotedEvent,
    this.modifiedEvent,
    this.content,
    this.videoPath,
    this.attachedMedia,
  });

  final EventReference? parentEvent;
  final EventReference? quotedEvent;
  final EventReference? modifiedEvent;
  final String? content;
  final String? videoPath;
  final String? attachedMedia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController =
        usePostQuillController(ref, content: content, modifiedEvent: modifiedEvent);
    final scrollController = useScrollController();
    final createOption = _determineCreateOption();

    final mediaFiles = useMemoized(
      () {
        if (attachedMedia != null) {
          final decodedList = jsonDecode(attachedMedia!) as List<dynamic>;
          return decodedList.map((item) {
            return MediaFile.fromJson(item as Map<String, dynamic>);
          }).toList();
        }
        return <MediaFile>[];
      },
      [attachedMedia],
    );

    final attachedMediaNotifier = useState<List<MediaFile>>(mediaFiles);
    final attachedVideoNotifier = useState<MediaFile?>(
      videoPath != null ? MediaFile(path: videoPath!) : null,
    );

    if (textEditorController == null) {
      return const SizedBox.shrink();
    }

    return BackHardwareButtonInterceptor(
      onBackPress: (_) async => textEditorController.document.isEmpty()
          ? context.pop()
          : await showSimpleBottomSheet<void>(
              context: context,
              child: CancelCreationModal(
                title: context.i18n.cancel_creation_post_title,
                onCancel: () => Navigator.of(context).pop(),
              ),
            ),
      child: SheetContent(
        topPadding: 0,
        body: Column(
          children: [
            CreatePostAppBar(
              createOption: createOption,
              textEditorController: textEditorController,
            ),
            Expanded(
              child: CreatePostContent(
                scrollController: scrollController,
                attachedVideoNotifier: attachedVideoNotifier,
                parentEvent: parentEvent,
                textEditorController: textEditorController,
                createOption: createOption,
                attachedMediaNotifier: attachedMediaNotifier,
                quotedEvent: quotedEvent,
              ),
            ),
            CreatePostBottomPanel(
              textEditorController: textEditorController,
              parentEvent: parentEvent,
              quotedEvent: quotedEvent,
              modifiedEvent: modifiedEvent,
              attachedMediaNotifier: attachedMediaNotifier,
              attachedVideoNotifier: attachedVideoNotifier,
              createOption: createOption,
            ),
          ],
        ),
      ),
    );
  }

  CreatePostOption _determineCreateOption() {
    if (modifiedEvent != null) return CreatePostOption.modify;
    if (videoPath != null) return CreatePostOption.video;
    if (parentEvent != null) return CreatePostOption.reply;
    if (quotedEvent != null) return CreatePostOption.quote;

    return CreatePostOption.plain;
  }
}
