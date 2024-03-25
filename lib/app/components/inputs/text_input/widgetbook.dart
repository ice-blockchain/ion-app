import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@widgetbook.UseCase(
  name: 'regular',
  type: TextInput,
)
Widget regularTextInputUseCase(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextInput(
              labelText: 'Basic text input',
            ),
            TextInput(
              enabled: false,
              labelText: 'Disabled',
            ),
            TextInput(
              verified: true,
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
              initialValue:
                  '0x93956a5688078e8f25df21ec0f24fd9fd7baf09545645645745',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0.s, horizontal: 16.0.s),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {}
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    ),
  );
}
