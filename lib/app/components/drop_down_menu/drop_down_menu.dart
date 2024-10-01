// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

/// Basically just a MenuAnchor with some predefined values from the Template
class DropDownMenu extends MenuAnchor {
  DropDownMenu({
    required super.menuChildren,
    super.key,
    super.controller,
    super.childFocusNode,
    super.style,
    Offset? alignmentOffset,
    super.clipBehavior = Clip.hardEdge,
    super.anchorTapClosesMenu = false,
    super.onOpen,
    super.onClose,
    super.crossAxisUnconstrained = true,
    super.builder,
    super.child,
  }) : super(
          alignmentOffset: alignmentOffset ?? Offset(0, 8.0.s),
        );
}
