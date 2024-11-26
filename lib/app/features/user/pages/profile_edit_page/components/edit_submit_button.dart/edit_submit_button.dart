import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:ion/app/features/user/providers/avatar_picker_notifier.dart';
import 'package:ion/app/features/user/providers/user_metadata_notifier.dart';
import 'package:ion/generated/assets.gen.dart';

class EditSubmitButton extends ConsumerWidget {
  const EditSubmitButton({
    required this.hasChanges,
    required this.draftRef,
    required this.formKey,
    super.key,
  });

  final bool hasChanges;

  final ObjectRef<UserMetadata> draftRef;

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(userMetadataNotifierProvider);

    return Button(
      disabled: !hasChanges,
      type: hasChanges ? ButtonType.primary : ButtonType.disabled,
      leadingIcon: ref.watch(userMetadataNotifierProvider).isLoading
          ? const IONLoadingIndicator()
          : Assets.svg.iconProfileSave.icon(
              color: context.theme.appColors.onPrimaryAccent,
            ),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final avatarFile =
              ref.watch(avatarPickerNotifierProvider).whenOrNull(processed: (file) => file);
          await ref
              .read(userMetadataNotifierProvider.notifier)
              .send(draftRef.value, avatar: avatarFile);
          if (context.mounted) {
            context.pop();
          }
        }
      },
      label: Text(context.i18n.profile_save),
      mainAxisSize: MainAxisSize.max,
    );
  }
}
