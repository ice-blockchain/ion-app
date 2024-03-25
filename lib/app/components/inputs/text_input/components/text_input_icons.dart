import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons_divider.dart';
import 'package:ice/app/extensions/num.dart';

class TextInputIcons extends StatelessWidget {
  const TextInputIcons({
    super.key,
    required this.icons,
    this.hasLeftDivider = false,
    this.hasRightDivider = false,
  });

  final List<Widget> icons;

  final bool hasLeftDivider;

  final bool hasRightDivider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (hasLeftDivider)
          Padding(
            padding: EdgeInsets.only(left: 16.0.s),
            child: const TextInputIconsDivider(),
          ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 56.0.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: icons,
          ),
        ),
        if (hasRightDivider)
          Padding(
            padding: EdgeInsets.only(right: 16.0.s),
            child: const TextInputIconsDivider(),
          ),
      ],
    );
  }
}
