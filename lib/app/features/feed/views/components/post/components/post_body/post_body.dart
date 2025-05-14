// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/text_editor_preview.dart';
import 'package:ion/app/components/text_editor/utils/is_attributed_operation.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/post_media.dart';
import 'package:ion/app/features/feed/views/components/url_preview_content/url_preview_content.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/views/hooks/use_parsed_media_content.dart';
import 'package:ion/app/typedefs/typedefs.dart';

class PostBody extends HookConsumerWidget {
  const PostBody({
    required this.entity,
    this.isShared = false,
    this.isTextSelectable = false,
    this.maxLines = 6,
    this.framedEventReference,
    this.sidePadding,
    this.onVideoTap,
    super.key,
  });

  final bool isShared;
  final IonConnectEntity entity;
  final bool isTextSelectable;
  final EventReference? framedEventReference;
  final int? maxLines;
  final double? sidePadding;
  final OnVideoTapCallback? onVideoTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postData = switch (entity) {
      final ModifiablePostEntity post => post.data,
      final PostEntity post => post.data,
      _ => null,
    };

    if (postData is! EntityDataWithMediaContent) {
      return const SizedBox.shrink();
    }

    final (:content, :media) = useParsedMediaContent(
      data: postData,
      key: ValueKey(postData.hashCode),
    );

    final firstLinkOperation = useMemoized(
      () => content.operations.firstWhereOrNull(
        (operation) => isAttributedOperation(operation, attribute: Attribute.link),
      ),
      [content],
    );

    final urlPreview = useMemoized(
      () => firstLinkOperation != null
          ? UrlPreviewContent(
              key: ValueKey(firstLinkOperation.value),
              url: firstLinkOperation.value as String,
            )
          : null,
      [firstLinkOperation],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = maxLines == null
            ? null
            : _calculateMaxHeight(
                context,
                text: Document.fromDelta(content).toPlainText(),
                style: context.theme.appTextThemes.body2,
                maxWidth: constraints.maxWidth,
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding ?? 16.0.s),
              child: Column(
                children: [
                  if (content.isNotEmpty && !content.isSingleLinkOnly)
                    ClipRect(
                      child: SizedBox(
                        height: maxHeight,
                        child: TextEditorPreview(
                          scrollable: false,
                          content: content,
                          customStyles: isShared
                              ? textEditorStyles(
                                  context,
                                  color: context.theme.appColors.onPrimaryAccent,
                                )
                              : null,
                          enableInteractiveSelection: isTextSelectable,
                          tagsColor: isShared ? context.theme.appColors.lightBlue : null,
                        ),
                      ),
                    ),
                  if (maxHeight != null)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        context.i18n.common_show_more,
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: isShared
                              ? context.theme.appColors.primaryBackground
                              : context.theme.appColors.darkBlue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (media.isNotEmpty)
              Padding(
                padding: EdgeInsetsDirectional.only(top: 10.0.s),
                child: PostMedia(
                  media: media,
                  eventReference: entity.toEventReference(),
                  sidePadding: sidePadding,
                  onVideoTap: onVideoTap,
                  framedEventReference: framedEventReference,
                ),
              ),
            if (media.isEmpty && urlPreview != null)
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: sidePadding ?? 16.0.s) +
                    EdgeInsetsDirectional.only(top: 10.0.s),
                child: urlPreview,
              ),
          ],
        );
      },
    );
  }

  double? _calculateMaxHeight(
    BuildContext context, {
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textScaler: MediaQuery.textScalerOf(context),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    if (textPainter.didExceedMaxLines) {
      return textPainter.height;
    }
    return null;
  }
}
