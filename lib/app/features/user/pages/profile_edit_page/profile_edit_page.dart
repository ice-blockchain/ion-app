// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
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
    final userMetadataValue = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    final nameController =
        useTextEditingController(text: userMetadataValue?.data.displayName ?? '');
    final nicknameController = useTextEditingController(text: userMetadataValue?.data.name ?? '');
    final bioController =
        useTextEditingWithHighlightsController(text: userMetadataValue?.data.about ?? '');
    final locationController = useTextEditingController(text: '');
    final websiteController = useTextEditingController(text: userMetadataValue?.data.website ?? '');
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
                                    NameInput(controller: nameController),
                                    SizedBox(height: paddingValue),
                                    NicknameInput(controller: nicknameController),
                                    SizedBox(height: paddingValue),
                                    BioInput(
                                      controller: bioController,
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
                                      controller: websiteController,
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
                        leadingIcon: Assets.svg.iconProfileSave.icon(
                          color: context.theme.appColors.onPrimaryAccent,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {}
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
