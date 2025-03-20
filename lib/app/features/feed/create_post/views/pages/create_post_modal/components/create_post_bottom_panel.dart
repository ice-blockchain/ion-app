// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_post/model/create_post_option.dart';
import 'package:ion/app/features/feed/create_post/views/components/character_limit_exceed_indicator/character_limit_exceed_indicator.dart';
import 'package:ion/app/features/feed/create_post/views/components/post_submit_button/post_submit_button.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/providers/selected_who_can_reply_option_provider.c.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_bold_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_image_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_italic_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_poll_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_regular_button.dart';
import 'package:ion/app/features/feed/views/pages/who_can_reply_settings_modal/who_can_reply_settings_modal.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class CreatePostBottomPanel extends StatelessWidget {
  const CreatePostBottomPanel({
    required this.textEditorController,
    required this.parentEvent,
    required this.quotedEvent,
    required this.modifiedEvent,
    required this.attachedMediaNotifier,
    required this.attachedVideoNotifier,
    required this.createOption,
    super.key,
  });

  final QuillController textEditorController;
  final EventReference? parentEvent;
  final EventReference? quotedEvent;
  final EventReference? modifiedEvent;
  final ValueNotifier<List<MediaFile>> attachedMediaNotifier;
  final ValueNotifier<MediaFile?> attachedVideoNotifier;
  final CreatePostOption createOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HorizontalSeparator(),
        _WhoCanReplySection(
          createOption: createOption,
          modifiedEvent: modifiedEvent,
        ),
        _ActionsSection(
          textEditorController: textEditorController,
          parentEvent: parentEvent,
          quotedEvent: quotedEvent,
          modifiedEvent: modifiedEvent,
          attachedMediaNotifier: attachedMediaNotifier,
          attachedVideoNotifier: attachedVideoNotifier,
          createOption: createOption,
        ),
      ],
    );
  }
}

class _WhoCanReplySection extends HookConsumerWidget {
  const _WhoCanReplySection({
    required this.createOption,
    this.modifiedEvent,
  });

  final CreatePostOption createOption;

  final EventReference? modifiedEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedWhoCanReplyOptionProvider);
    final modifiableEntity = modifiedEvent != null
        ? ref.watch(ionConnectEntityProvider(eventReference: modifiedEvent!)).valueOrNull
        : null;

    useOnInit(
      () async {
        if (modifiableEntity != null && modifiableEntity is ModifiablePostEntity) {
          ref.read(selectedWhoCanReplyOptionProvider.notifier).option =
              modifiableEntity.data.whoCanReplySetting;
        }
      },
      [modifiableEntity],
    );

    return ScreenSideOffset.small(
      child: ListItem(
        title: Text(
          selectedOption.getTitle(context),
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
        contentPadding: EdgeInsets.zero,
        backgroundColor: context.theme.appColors.secondaryBackground,
        leading: selectedOption.getIcon(context),
        trailing: Assets.svg.iconArrowRight.icon(
          color: context.theme.appColors.primaryAccent,
        ),
        constraints: BoxConstraints(minHeight: 40.0.s),
        onTap: () => showSimpleBottomSheet<void>(
          context: context,
          child: WhoCanReplySettingsModal(
            title: createOption == CreatePostOption.video
                ? context.i18n.who_can_reply_settings_title_video
                : context.i18n.who_can_reply_settings_title_post,
          ),
        ),
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection({
    required this.textEditorController,
    required this.parentEvent,
    required this.quotedEvent,
    required this.modifiedEvent,
    required this.attachedMediaNotifier,
    required this.attachedVideoNotifier,
    required this.createOption,
  });

  final QuillController textEditorController;
  final EventReference? parentEvent;
  final EventReference? quotedEvent;
  final EventReference? modifiedEvent;
  final ValueNotifier<List<MediaFile>> attachedMediaNotifier;
  final ValueNotifier<MediaFile?> attachedVideoNotifier;
  final CreatePostOption createOption;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: ActionsToolbar(
        actions: [
          if (modifiedEvent == null)
            ToolbarImageButton(
              delegate: AttachedMediaHandler(attachedMediaNotifier),
            ),
          ToolbarPollButton(textEditorController: textEditorController),
          ToolbarRegularButton(textEditorController: textEditorController),
          ToolbarItalicButton(textEditorController: textEditorController),
          ToolbarBoldButton(textEditorController: textEditorController),
        ],
        trailing: Row(
          children: [
            CharacterLimitExceedIndicator(
              maxCharacters: ModifiablePostEntity.contentCharacterLimit,
              textEditorController: textEditorController,
            ),
            SizedBox(width: 8.0.s),
            PostSubmitButton(
              textEditorController: textEditorController,
              parentEvent: parentEvent,
              quotedEvent: quotedEvent,
              modifiedEvent: modifiedEvent,
              mediaFiles: [
                ...attachedMediaNotifier.value,
                if (attachedVideoNotifier.value != null) attachedVideoNotifier.value!,
              ],
              createOption: createOption,
            ),
          ],
        ),
      ),
    );
  }
}
