// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/back_hardware_button_interceptor/back_hardware_button_interceptor.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/components/text_editor/components/suggestions_container.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_modal/components/create_article_add_image.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_modal/components/create_article_toolbar.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_modal/hooks/use_create_article.dart';
import 'package:ion/app/features/feed/views/pages/cancel_creation_modal/cancel_creation_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class CreateArticleModal extends HookConsumerWidget {
  const CreateArticleModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleState = useCreateArticle(ref);
    final scrollController = useScrollController();
    final textEditorKey = useMemoized(TextEditorKeys.createArticle);

    Future<bool?> showCancelCreationModal(BuildContext context) {
      return showSimpleBottomSheet<bool>(
        context: context,
        child: CancelCreationModal(
          title: context.i18n.cancel_creation_article_title,
          onCancel: () => Navigator.of(context).pop(true),
        ),
      );
    }

    return BackHardwareButtonInterceptor(
      onBackPress: (context) async {
        await showCancelCreationModal(context);
      },
      child: SheetContent(
        bottomPadding: 0,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: Text(context.i18n.create_article_nav_title),
              onBackPress: () {
                showCancelCreationModal(context);
              },
              actions: [
                Button(
                  type: ButtonType.secondary,
                  label: Text(
                    context.i18n.button_next,
                    style: context.theme.appTextThemes.body.copyWith(
                      color: articleState.isButtonEnabled
                          ? context.theme.appColors.primaryAccent
                          : context.theme.appColors.sheetLine,
                    ),
                  ),
                  backgroundColor: context.theme.appColors.secondaryBackground,
                  borderColor: context.theme.appColors.secondaryBackground,
                  disabled: !articleState.isButtonEnabled,
                  onPressed: () {
                    articleState.onNext();
                    ArticlePreviewRoute().push<void>(context);
                  },
                ),
              ],
            ),
            Expanded(
              child: KeyboardDismissOnTap(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      CreateArticleAddImage(
                        selectedImage: articleState.selectedImage,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: ScreenSideOffset.defaultSmallMargin,
                          right: ScreenSideOffset.defaultSmallMargin,
                          top: ScreenSideOffset.defaultSmallMargin,
                          bottom: 6.0.s,
                        ),
                        child: TextField(
                          controller: articleState.titleController,
                          focusNode: articleState.titleFocusNode,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            articleState.editorFocusNotifier.value = true;
                          },
                          inputFormatters: articleState.titleInputFormatters,
                          style: context.theme.appTextThemes.headline2.copyWith(
                            color: context.theme.appColors.primaryText,
                          ),
                          decoration: InputDecoration(
                            hintText: context.i18n.create_article_title_placeholder,
                            hintStyle: context.theme.appTextThemes.headline2.copyWith(
                              color: context.theme.appColors.tertararyText,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      ScreenSideOffset.small(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: articleState.editorFocusNotifier,
                          builder: (context, isFocused, child) {
                            return TextEditor(
                              autoFocus: isFocused,
                              articleState.textEditorController,
                              placeholder: context.i18n.create_article_story_placeholder,
                              key: textEditorKey,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16.0.s,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SuggestionsContainer(
                  scrollController: scrollController,
                  editorKey: textEditorKey,
                ),
                const HorizontalSeparator(),
                ValueListenableBuilder<bool>(
                  valueListenable: articleState.isTitleFocused,
                  builder: (context, isTitleFocused, child) {
                    if (isTitleFocused) {
                      return const SizedBox.shrink();
                    }
                    return ScreenSideOffset.small(
                      child: CreateArticleToolbar(
                        textEditorController: articleState.textEditorController,
                        textEditorKey: textEditorKey,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
