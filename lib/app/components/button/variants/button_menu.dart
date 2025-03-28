// SPDX-License-Identifier: ice License 1.0

part of '../button.dart';

class _ButtonMenu extends Button {
  _ButtonMenu({
    required super.onPressed,
    super.key,
    super.trailingIcon,
    super.leadingIcon,
    super.label,
    super.mainAxisSize,
    super.disabled,
    super.backgroundColor,
    super.borderColor,
    ButtonStyle style = const ButtonStyle(),
    bool active = false,
  }) : super(
          type: active ? ButtonType.menuActive : ButtonType.menuInactive,
          style: style.merge(
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0.s)),
              ),
              minimumSize: Size.square(40.0.s),
              padding: leadingIcon != null
                  ? EdgeInsetsDirectional.only(
                      start: 4.0.s,
                      end: active ? 12.0.s : 20.0.s,
                    )
                  : EdgeInsets.symmetric(horizontal: 14.0.s),
            ),
          ),
          leadingIconOffset: active ? 10.0.s : 2.0.s,
        );
}
