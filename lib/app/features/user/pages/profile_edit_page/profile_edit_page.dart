// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/bio_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/location_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/name_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/nickname_input.dart';
import 'package:ion/app/features/auth/views/components/user_data_inputs/website_input.dart';
import 'package:ion/app/features/user/model/user_category_type.dart';
import 'package:ion/app/features/user/pages/components/background_picture/background_picture.dart';
import 'package:ion/app/features/user/pages/components/profile_avatar/profile_avatar.dart';
import 'package:ion/app/features/user/pages/profile_edit_page/components/category_selector/category_selector.dart';
import 'package:ion/app/features/user/pages/profile_edit_page/components/header/header.dart';
import 'package:ion/app/features/user/pages/profile_edit_page/hooks/use_draft_metadata.dart';
import 'package:ion/app/features/user/providers/user_metadata_notifier.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class ProfileEditPage extends HookConsumerWidget {
  const ProfileEditPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  static double get paddingValue => 20.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final userMetadata = ref.watch(userMetadataProvider(pubkey)).valueOrNull;

    ref.displayErrors(userMetadataNotifierProvider);

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    final (:hasChanges, :userMetadataDraftRef, :update) = useDraftMetadata(userMetadata.data);

    final locationController = useTextEditingController(text: '');
    final category = useState<UserCategoryType?>(null);

    return Scaffold(
      body: KeyboardDismissOnTap(
        child: Stack(
          children: [
            Positioned(
              child: BackgroundPicture(pubkey: pubkey),
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ScreenTopOffset(
                      child: Column(
                        children: [
                          SizedBox(height: 60.0.s),
                          Container(
                            decoration: BoxDecoration(
                              color: context.theme.appColors.secondaryBackground,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.s)),
                            ),
                            child: ScreenSideOffset.large(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    ProfileAvatar(
                                      pubkey: pubkey,
                                      showAvatarPicker: true,
                                    ),
                                    SizedBox(height: paddingValue),
                                    NameInput(
                                      initialValue: userMetadata.data.displayName,
                                      onChanged: (text) {
                                        update(
                                            userMetadataDraftRef.value.copyWith(displayName: text));
                                      },
                                    ),
                                    SizedBox(height: paddingValue),
                                    NicknameInput(
                                      initialValue: userMetadata.data.name,
                                      onChanged: (text) {
                                        update(userMetadataDraftRef.value.copyWith(name: text));
                                      },
                                    ),
                                    SizedBox(height: paddingValue),
                                    BioInput(
                                      controller: useTextEditingWithHighlightsController(
                                        text: userMetadata.data.about,
                                      ),
                                      onChanged: (text) {
                                        update(
                                          userMetadataDraftRef.value.copyWith(
                                            about: text.isEmpty ? null : text,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: paddingValue),
                                    CategorySelector(
                                      selectedUserCategoryType: category.value,
                                      onPressed: () async {
                                        final newUserCategoryType = await CategorySelectRoute(
                                          pubkey: pubkey,
                                          selectedUserCategoryType: category.value,
                                        ).push<UserCategoryType?>(context);
                                        if (newUserCategoryType != null) {
                                          category.value = newUserCategoryType;
                                        }
                                      },
                                    ),
                                    SizedBox(height: paddingValue),
                                    LocationInput(
                                      controller: locationController,
                                    ),
                                    SizedBox(height: paddingValue),
                                    WebsiteInput(
                                      initialValue: userMetadata.data.website,
                                      onChanged: (text) {
                                        update(
                                          userMetadataDraftRef.value.copyWith(
                                            website: text.isEmpty ? null : text,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: paddingValue),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HorizontalSeparator(),
                    SizedBox(height: 16.0.s),
                    ScreenSideOffset.large(
                      child: Button(
                        disabled: !hasChanges,
                        type: hasChanges ? ButtonType.primary : ButtonType.disabled,
                        leadingIcon: ref.watch(userMetadataNotifierProvider).isLoading
                            ? const IONLoadingIndicator()
                            : Assets.svg.iconProfileSave.icon(
                                color: context.theme.appColors.onPrimaryAccent,
                              ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(userMetadataNotifierProvider.notifier)
                                .send(userMetadataDraftRef.value);
                            if (context.mounted) {
                              context.pop();
                            }
                          }
                        },
                        label: Text(context.i18n.profile_save),
                        mainAxisSize: MainAxisSize.max,
                      ),
                    ),
                    SizedBox(height: paddingValue),
                  ],
                ),
              ],
            ),
            Positioned(
              child: Header(pubkey: pubkey),
            ),
          ],
        ),
      ),
    );
  }
}
