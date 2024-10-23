// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/code_block_type_item.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/code_types.dart';

class CodeBlockTypesToolbar extends HookWidget {
  const CodeBlockTypesToolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);
    final selectedType = useState(CodeBlockType.plainText);

    const codeBlockTypes = CodeBlockType.values;

    final restOfItems = codeBlockTypes.where((type) => type != selectedType.value).toList();

    final itemsToRender = [selectedType.value];
    if (isExpanded.value) {
      itemsToRender.addAll(restOfItems);
    }

    return SizedBox(
      height: 21.0.s,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.0.s),
        scrollDirection: Axis.horizontal,
        itemCount: itemsToRender.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.0.s),
        itemBuilder: (context, index) {
          final codeBlockType = itemsToRender[index];
          return CodeBlockTypeItem(
            type: codeBlockType,
            onTap: () {
              if (isExpanded.value) {
                selectedType.value = codeBlockType;
                isExpanded.value = false;
              } else {
                isExpanded.value = true;
              }
            },
            isSelected: codeBlockType == selectedType.value,
          );
        },
      ),
    );
  }
}
