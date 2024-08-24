import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/data/models/twofa_type.dart';
import 'package:ice/app/features/auth/views/pages/twofa_options/twofa_option_selector.dart';

class TwoFaOptionSelectorList extends HookWidget {
  final int optionsAmount;
  final void Function(TwoFaType?) onOptionSaved;

  const TwoFaOptionSelectorList({
    super.key,
    required this.optionsAmount,
    required this.onOptionSaved,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValues = {for (int i = 0; i < optionsAmount; i++) i: useState<TwoFaType?>(null)};
    final availableOptions = useState<Set<TwoFaType>>(TwoFaType.values.toSet());

    return Column(
      children: List.generate(
        optionsAmount,
        (option) {
          return Padding(
            padding: EdgeInsets.only(bottom: 22.0.s),
            child: TwoFaOptionSelector(
              availableOptions: selectedValues[option]?.value != null
                  ? {selectedValues[option]!.value!, ...availableOptions.value}
                  : availableOptions.value,
              optionIndex: option + 1,
              onSaved: onOptionSaved,
            ),
          );
        },
      ),
    );
  }
}
