import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/features/auth/views/pages/twofa_codes/twofa_code_input.dart';

class TwoFaCodeInputList extends HookWidget {
  final List<TwoFaType> twoFaTypes;

  const TwoFaCodeInputList({
    super.key,
    required this.twoFaTypes,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = {
      for (final type in twoFaTypes)
        type: useTextEditingController.fromValue(TextEditingValue.empty),
    };

    return Column(
      children: twoFaTypes.map((twoFaType) {
        return Padding(
          padding: EdgeInsets.only(bottom: 22.0.s),
          child: TwoFaCodeInput(
            controller: controllers[twoFaType]!,
            twoFaType: twoFaType,
          ),
        );
      }).toList(),
    );
  }
}
