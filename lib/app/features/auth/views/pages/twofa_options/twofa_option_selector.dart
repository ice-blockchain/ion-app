import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/generated/assets.gen.dart';

class TwoFaOptionSelector extends HookWidget {
  const TwoFaOptionSelector({
    required this.availableOptions,
    required this.optionIndex,
    required this.onSaved,
    super.key,
  });

  final Set<TwoFaType> availableOptions;
  final int optionIndex;
  final FormFieldSetter<TwoFaType?> onSaved;

  @override
  Widget build(BuildContext context) {
    final isOpened = useState(false);
    final height = 58.0.s;
    final iconBorderSize = BorderSide(color: context.theme.appColors.onTerararyFill, width: 1.0.s);

    return FormField<TwoFaType?>(
      validator: (option) {
        if (option == null) {
          return '';
        }
        return null;
      },
      onSaved: onSaved,
      builder: (state) {
        return Container(
          width: double.infinity,
          height: height,
          child: DropDownMenu(
            style: MenuStyle(
              elevation: WidgetStateProperty.all(0),
              side: WidgetStateProperty.all(
                  BorderSide(color: context.theme.appColors.strokeElements, width: 1.0.s)),
              minimumSize: WidgetStateProperty.all(
                Size(MediaQuery.of(context).size.width - ScreenSideOffset.defaultLargeMargin * 2,
                    height),
              ),
            ),
            crossAxisUnconstrained: false,
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return Button.dropdown(
                useDefaultBorderRadius: true,
                useDefaultPaddings: true,
                backgroundColor: context.theme.appColors.secondaryBackground,
                borderColor: state.hasError
                    ? context.theme.appColors.attentionRed
                    : context.theme.appColors.strokeElements,
                leadingIcon: ButtonIconFrame(
                  color: context.theme.appColors.tertararyBackground,
                  icon: (state.value?.iconAsset ?? Assets.images.icons.iconSelect2).icon(
                    size: 20.0.s,
                    color: context.theme.appColors.secondaryText,
                  ),
                  border: iconBorderSize,
                ),
                label: Container(
                  width: double.infinity,
                  child: Text(
                    state.value?.getDisplayName(context) ?? context.i18n.two_fa_select(optionIndex),
                  ),
                ),
                opened: isOpened.value,
                onPressed: () {
                  isOpened.value = !isOpened.value;
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
            menuChildren: <MenuItemButton>[
              for (final TwoFaType option in availableOptions)
                MenuItemButton(
                  onPressed: () {
                    state.didChange(option);
                    state.save();
                    state.validate();
                    isOpened.value = false;
                  },
                  leadingIcon: ButtonIconFrame(
                    color: context.theme.appColors.secondaryBackground,
                    icon: option.iconAsset.icon(
                      size: 20.0.s,
                      color: context.theme.appColors.secondaryText,
                    ),
                    border: iconBorderSize,
                  ),
                  child: Text(
                    option.getDisplayName(context),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
