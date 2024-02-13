import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';

class InputFieldBorder extends OutlineInputBorder {
  InputFieldBorder({
    BorderSide? borderSide,
  }) : super(
          borderSide: borderSide ?? const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
        );

  factory InputFieldBorder.focused() => InputFieldBorder(
        borderSide:
            BorderSide(color: appTemplateTheme.colors.light.primaryAccent),
      );

  factory InputFieldBorder.error() => InputFieldBorder(
        borderSide:
            BorderSide(color: appTemplateTheme.colors.light.attentionRed),
      );
}
