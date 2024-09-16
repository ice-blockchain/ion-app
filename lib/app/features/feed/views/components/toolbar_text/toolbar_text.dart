import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/data/models/toolbar.dart';

class ToolbarText extends HookWidget {
  const ToolbarText({
    super.key,
  });

  Widget _buildButton(ToolbarTextButtonType buttonType, bool isSelected, BuildContext context,
      VoidCallback? onPress) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.only(right: 12.0.s),
        child: Container(
          height: 24.0.s,
          child: buttonType.getIconAsset(isSelected).icon(size: 24.0.s),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = useState(ToolbarTextButtonType.regular);

    VoidCallback onPress(ToolbarTextButtonType type) {
      return () {
        if (type != selectedType.value) {
          selectedType.value = type;
        }
      };
    }

    return Container(
      height: 40.0.s,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildButton(
              ToolbarTextButtonType.regular,
              selectedType.value == ToolbarTextButtonType.regular,
              context,
              onPress(ToolbarTextButtonType.regular)),
          _buildButton(ToolbarTextButtonType.bold, selectedType.value == ToolbarTextButtonType.bold,
              context, onPress(ToolbarTextButtonType.bold)),
          _buildButton(
              ToolbarTextButtonType.italic,
              selectedType.value == ToolbarTextButtonType.italic,
              context,
              onPress(ToolbarTextButtonType.italic)),
        ],
      ),
    );
  }
}
