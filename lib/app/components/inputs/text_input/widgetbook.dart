import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_clear_button.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_text_button.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@widgetbook.UseCase(
  name: 'regular',
  type: TextInput,
)
Widget regularTextInputUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextInput(
                labelText: 'Basic text input',
              ),
              TextInput(
                enabled: false,
                labelText: 'Disabled',
              ),
              TextInput(
                verified: true,
                initialValue: 'Some correct value',
                labelText: 'Validated',
              ),
              TextInput(
                validator: (String? v) {
                  if (v.isEmpty) return '';
                  if (!EmailValidator.validate(v!)) {
                    return 'Invalid email';
                  }
                  return null;
                },
                labelText: 'With email validator',
              ),
              TextInput(
                maxLines: 2,
                minLines: 2,
                labelText: 'Multiline',
                initialValue: '0x93956a5688078e8f25df21ec0f24fd9fd7baf09545645645745',
                contentPadding: EdgeInsets.symmetric(vertical: 5.0.s, horizontal: 16.0.s),
              ),
              TextInput(
                labelText: 'Basic text input with prefix icon',
                prefixIcon: TextInputIcons(
                  icons: [
                    Assets.images.icons.iconBadgeCompany.icon(),
                  ],
                  hasRightDivider: true,
                ),
              ),
              TextInput(
                labelText: 'Basic text input with suffix buttons',
                suffixIcon: TextInputIcons(
                  icons: [
                    IconButton(
                      icon: Assets.images.icons.iconBlockEyeOn.icon(),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Assets.images.icons.iconArrowDown.icon(),
                      onPressed: () {},
                    ),
                  ],
                  hasLeftDivider: true,
                ),
              ),
              TextInput(
                labelText: 'Basic text input with suffix button',
                suffixIcon: TextInputTextButton(
                  onPressed: () {},
                  label: 'max',
                ),
              ),
              const TextInputWithClear(),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState!.validate()) {}
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class TextInputWithClear extends HookWidget {
  const TextInputWithClear({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    return TextInput(
      controller: controller,
      labelText: 'With clear button',
      prefixIcon: TextInputIcons(
        icons: [
          Assets.images.icons.iconBadgeCompany.icon(),
        ],
        hasRightDivider: true,
      ),
      suffixIcon: TextInputIcons(
        icons: [
          TextInputClearButton(
            controller: controller,
          ),
        ],
      ),
    );
  }
}
