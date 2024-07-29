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
    double? leadingIconOffset,
    double? trailingIconOffset,
    bool opened = false,
    ButtonStyle style = const ButtonStyle(),
    bool useDefaultBorderRadius = false,
    bool useDefaultPaddings = false,
  }) : super(
          type: ButtonType.dropdown,
          style: style.merge(
            OutlinedButton.styleFrom(
              shape: useDefaultBorderRadius == true
                  ? null
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0.s)),
                    ),
              minimumSize: Size.square(40.0.s),
              padding: useDefaultPaddings == true
                  ? null
                  : leadingIcon != null
                      ? EdgeInsets.only(
                          left: 4.0.s,
                          right: 10.0.s,
                        )
                      : EdgeInsets.symmetric(horizontal: 14.0.s),
            ),
          ),
          leadingIconOffset: leadingIconOffset ?? 10.0.s,
          trailingIcon:
              (opened ? Assets.images.icons.iconArrowUp : Assets.images.icons.iconArrowDown).icon(),
          trailingIconOffset: trailingIconOffset ?? 8.0.s,
        );
}
