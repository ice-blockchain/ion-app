import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/data/models/toolbar.dart';

class ActionsToolbarFont extends HookWidget {
  const ActionsToolbarFont({
    super.key,
    this.onTextStyleChange,
  });

  final ValueChanged<ToolbarTextButtonType>? onTextStyleChange;

  @override
  Widget build(BuildContext context) {
    final selectedType = useState(ToolbarTextButtonType.regular);

    VoidCallback onPress(ToolbarTextButtonType type) {
      return () {
        if (type != selectedType.value) {
          onTextStyleChange?.call(type);
          selectedType.value = type;
        }
      };
    }

    return Container(
      height: 40.0.s,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(ToolbarTextButtonType.values.length, (index) {
          final buttonType = ToolbarTextButtonType.values[index];
          return _TextStyleButton(
            buttonType: buttonType,
            isSelected: selectedType.value == buttonType,
            onPress: onPress(buttonType),
          );
        }),
      ),
    );
  }
}

class _TextStyleButton extends StatelessWidget {
  final ToolbarTextButtonType buttonType;
  final bool isSelected;
  final VoidCallback? onPress;

  const _TextStyleButton({
    required this.buttonType,
    required this.isSelected,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: EdgeInsets.only(right: 12.0.s),
        child: SizedBox(
          height: 24.0.s,
          child: buttonType.getIconAsset(isSelected).icon(size: 24.0.s),
        ),
      ),
    );
  }
}
