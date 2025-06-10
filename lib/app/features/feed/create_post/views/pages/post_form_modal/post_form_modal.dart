// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/back_hardware_button_interceptor/back_hardware_button_interceptor.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/create_post_app_bar.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/create_post_bottom_panel.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/components/create_post_content.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_form_modal/hooks/use_post_quill_controller.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/pages/cancel_creation_modal/cancel_creation_modal.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

class PostFormModal extends HookConsumerWidget {
  const PostFormModal._({
    required this.createOption,
    super.key,
    this.parentEvent,
    this.quotedEvent,
    this.modifiedEvent,
    this.content,
    this.videoPath,
    this.attachedMedia,
    this.mimeType,
  });

  factory PostFormModal.createPost({
    Key? key,
    String? content,
    String? attachedMedia,
  }) {
    return PostFormModal._(
      key: key,
      createOption: CreatePostOption.plain,
      content: content,
      attachedMedia: attachedMedia,
    );
  }

  factory PostFormModal.editPost({
    required EventReference modifiedEvent,
    Key? key,
    String? content,
    String? attachedMedia,
  }) {
    return PostFormModal._(
      key: key,
      createOption: CreatePostOption.modify,
      modifiedEvent: modifiedEvent,
      content: content,
      attachedMedia: attachedMedia,
    );
  }

  factory PostFormModal.createReply({
    required EventReference parentEvent,
    Key? key,
    String? content,
    String? attachedMedia,
  }) {
    return PostFormModal._(
      key: key,
      createOption: CreatePostOption.reply,
      parentEvent: parentEvent,
      content: content,
      attachedMedia: attachedMedia,
    );
  }

  factory PostFormModal.editReply({
    required EventReference parentEvent,
    required EventReference modifiedEvent,
    Key? key,
    String? content,
    String? attachedMedia,
  }) {
    return PostFormModal._(
      key: key,
      createOption: CreatePostOption.reply,
      parentEvent: parentEvent,
      modifiedEvent: modifiedEvent,
      content: content,
      attachedMedia: attachedMedia,
    );
  }

  factory PostFormModal.createQuote({
    required EventReference quotedEvent,
    Key? key,
    String? content,
    String? attachedMedia,
  }) {
    return PostFormModal._(
      key: key,
      createOption: CreatePostOption.quote,
      quotedEvent: quotedEvent,
      content: content,
      attachedMedia: attachedMedia,
    );
  }

  factory PostFormModal.editQuote({
    required EventReference quotedEvent,
    required EventReference modifiedEvent,
    Key? key,
    String? content,
    String? attachedMedia,
  }) {
    return PostFormModal._(
      key: key,
      createOption: CreatePostOption.quote,
      quotedEvent: quotedEvent,
      modifiedEvent: modifiedEvent,
      content: content,
      attachedMedia: attachedMedia,
    );
  }

  factory PostFormModal.video({
    required String videoPath,
    required String mimeType,
    Key? key,
    String? content,
  }) {
    return PostFormModal._(
      key: key,
      createOption: CreatePostOption.video,
      videoPath: videoPath,
      mimeType: mimeType,
      content: content,
    );
  }

  final CreatePostOption createOption;
  final EventReference? parentEvent;
  final EventReference? quotedEvent;
  final EventReference? modifiedEvent;
  final String? content;
  final String? videoPath;
  final String? attachedMedia;
  final String? mimeType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditorController =
        usePostQuillController(ref, content: content, modifiedEvent: modifiedEvent);
    final scrollController = useScrollController();
    final textEditorKey = useMemoized(TextEditorKeys.createPost);

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
      videoPath != null && mimeType != null
          ? MediaFile(
              path: videoPath!,
              mimeType: mimeType,
            )
          : null,
    );
    final attachedMediaLinksNotifier = useState<Map<String, MediaAttachment>>({});

    if (modifiedEvent != null) {
      useEffect(
        () {
          final modifiedEntity =
              ref.read(ionConnectEntityProvider(eventReference: modifiedEvent!)).valueOrNull;

          if (modifiedEntity is! ModifiablePostEntity) {
            throw UnsupportedEventReference(modifiedEvent);
          }
          attachedMediaLinksNotifier.value = modifiedEntity.data.media;

          return null;
        },
        [],
      );
    }

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
                attachedMediaLinksNotifier: attachedMediaLinksNotifier,
                quotedEvent: quotedEvent,
                textEditorKey: textEditorKey,
              ),
            ),
            CreatePostBottomPanel(
              textEditorController: textEditorController,
              parentEvent: parentEvent,
              quotedEvent: quotedEvent,
              modifiedEvent: modifiedEvent,
              attachedMediaNotifier: attachedMediaNotifier,
              attachedVideoNotifier: attachedVideoNotifier,
              attachedMediaLinksNotifier: attachedMediaLinksNotifier,
              createOption: createOption,
              scrollController: scrollController,
              textEditorKey: textEditorKey,
            ),
          ],
        ),
      ),
    );
  }
}
