import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/protect_account/authenticator/data/model/authenticator_type.dart';
import 'package:ice/app/features/protect_account/components/secure_account_option.dart';

class AuthenticatorOptionsPage extends StatelessWidget {
  const AuthenticatorOptionsPage({
    required this.onTap,
    super.key,
  });

  final void Function(AutethenticatorType type) onTap;

  @override
  Widget build(BuildContext context) {
    const authenticatorTypes = AutethenticatorType.values;

    return Column(
      children: [
        SizedBox(height: 32.0.s),
        Expanded(
          child: ListView.builder(
            itemCount: authenticatorTypes.length,
            itemBuilder: (context, index) {
              final type = authenticatorTypes[index];

              return Padding(
                padding: EdgeInsets.only(bottom: 12.0.s),
                child: SecureAccountOption(
                  isEnabled: false,
                  title: type.getDisplayName(context),
                  icon: type.iconAsset.icon(),
                  onTap: () => onTap(type),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
