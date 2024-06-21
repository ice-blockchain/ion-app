part of '../button.dart';

class _ButtonDropdown extends Button {
  _ButtonDropdown({
    required super.onPressed,
    super.key,
    super.leadingIcon,
    super.label,
    super.disabled,
    super.backgroundColor,
    super.borderColor,
    double? leadingButtonOffset,
    double? trailingIconOffset,
    bool opened = false,
    ButtonStyle style = const ButtonStyle(),
  }) : super(
          type: ButtonType.dropdown,
          style: style.merge(
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(UiSize.medium)),
              ),
              minimumSize: Size.square(40.0.s),
              padding: leadingIcon != null
                  ? EdgeInsets.only(
                      left: UiSize.xSmall,
                      right: UiSize.smallMedium,
                    )
                  : EdgeInsets.symmetric(horizontal: 14.0.s),
            ),
          ),
          leadingIconOffset: leadingButtonOffset ?? UiSize.smallMedium,
          trailingIcon: (opened
                  ? Assets.images.icons.iconArrowUp
                  : Assets.images.icons.iconArrowDown)
              .icon(),
          trailingIconOffset: trailingIconOffset ?? UiSize.small,
        );
}
