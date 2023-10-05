import 'package:flutter/material.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';

/// Basically just a MenuAnchor with some predefined values from the Template
class DropDownMenu extends StatelessWidget {
  const DropDownMenu({
    super.key,
    this.controller,
    this.childFocusNode,
    this.style,
    this.alignmentOffset,
    this.clipBehavior = Clip.hardEdge,
    this.anchorTapClosesMenu = false,
    this.onOpen,
    this.onClose,
    this.crossAxisUnconstrained = true,
    required this.menuChildren,
    this.builder,
    this.child,
  });
  final MenuController? controller;
  final FocusNode? childFocusNode;
  final MenuStyle? style;
  final Offset? alignmentOffset;
  final Clip clipBehavior;
  final bool anchorTapClosesMenu;
  final void Function()? onOpen;
  final void Function()? onClose;
  final bool crossAxisUnconstrained;
  final List<Widget> menuChildren;
  final Widget Function(BuildContext, MenuController, Widget?)? builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      key: key,
      alignmentOffset:
          alignmentOffset ?? Offset(0, appTemplate.menuAnchor.alignmentOffsetY),
      controller: controller,
      childFocusNode: childFocusNode,
      style: style,
      clipBehavior: clipBehavior,
      anchorTapClosesMenu: anchorTapClosesMenu,
      onOpen: onOpen,
      onClose: onClose,
      crossAxisUnconstrained: crossAxisUnconstrained,
      menuChildren: menuChildren,
      builder: builder,
      child: child,
    );
  }
}
