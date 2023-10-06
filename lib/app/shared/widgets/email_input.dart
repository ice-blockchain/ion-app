import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class EmailInput extends HookWidget {
  const EmailInput({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = useFocusNode();
    final ValueNotifier<bool> isFocused = useState<bool>(false);

    useEffect(
      () {
        void handleFocus() {
          isFocused.value = focusNode.hasFocus;
        }

        focusNode.addListener(handleFocus);

        return () => focusNode.removeListener(handleFocus);
      },
      <FocusNode>[focusNode],
    );

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: 'Email address',
              prefixIcon: isFocused.value
                  ? null
                  : IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 20),
                          Image.asset(
                            Assets.images.fieldEmail.path,
                            color: context.theme.appColors.primaryText,
                          ),
                          const SizedBox(width: 6),
                          VerticalDivider(
                            color: context.theme.appColors.strokeElements,
                            thickness: 1,
                            indent: 14,
                            endIndent: 14,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
              filled: true,
              // you may use conditions to set different colors for different states
              fillColor: context.theme.appColors.secondaryBackground,
              // you may use the OutlineInputBorder,
              // or extend the InputBorder class to create your own
              // the default is UnderlineInputBorder
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              // you can also define different border styles for different states
              // e.g. when the field is enabled / focused / has error
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: context.theme.appColors.strokeElements),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    BorderSide(color: context.theme.appColors.primaryAccent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
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
