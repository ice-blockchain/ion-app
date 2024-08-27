import 'package:ice/app/features/auth/views/pages/protect_account/models/security_methods.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_account_provider.g.dart';

@Riverpod(keepAlive: true)
class SecurityAccountController extends _$SecurityAccountController {
  @override
  SecurityMethods build() {
    return const SecurityMethods();
  }

  void toggleBackup(bool value) => state = state.copyWith(isBackupEnabled: value);

  void toggleEmail(bool value) => state = state.copyWith(isEmailEnabled: value);

  void toggleAuthenticator(bool value) => state = state.copyWith(isAuthenticatorEnabled: value);

  void togglePhone(bool value) => state = state.copyWith(isPhoneEnabled: value);
}
