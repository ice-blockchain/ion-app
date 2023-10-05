import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              labelText: 'Email address',
              filled: true,
              // you may use conditions to set different colors for different states
              fillColor: context.theme.appColors.secondaryBackground,
              // you may use the OutlineInputBorder,
              // or extend the InputBorder class to create your own
              // the default is UnderlineInputBorder
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              // you can also define different border styles for different states
              // e.g. when the field is enabled / focused / has error
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: context.theme.appColors.primaryAccent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
            ),
            validator: (String? email) {
              if (email != null && !EmailValidator.validate(email)) {
                return 'Invalid email format';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
