import 'package:ion_identity_client/src/auth/result_types/create_recovery_credentials_result.dart';
import 'package:ion_identity_client/src/auth/result_types/login_user_result.dart';
import 'package:ion_identity_client/src/auth/result_types/register_user_result.dart';
import 'package:ion_identity_client/src/auth/services/create_recovery_credentials_service.dart';
import 'package:ion_identity_client/src/auth/services/login_service.dart';
import 'package:ion_identity_client/src/auth/services/register_service.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';

/// A class that handles user authentication processes, including user registration,
/// login, and logout.
class IonAuth {
  /// Constructs an [IonAuth] instance with the provided services and token storage.
  ///
  /// The [username] is the identifier for the user.
  /// The [registerService] handles user registration.
  /// The [loginService] handles user login.
  /// The [tokenStorage] manages the storage of authentication tokens.
  /// The [recoveryKeyService] handles the creation of recovery credentials.
  IonAuth({
    required this.username,
    required this.registerService,
    required this.loginService,
    required this.tokenStorage,
    required this.recoveryKeyService,
  });

  final RegisterService registerService;
  final LoginService loginService;
  final CreateRecoveryCredentialsService recoveryKeyService;

  final String username;
  final TokenStorage tokenStorage;

  Future<RegisterUserResult> registerUser() => registerService.registerUser();
  Future<LoginUserResult> loginUser() => loginService.loginUser();
  Future<CreateRecoveryCredentialsResult> createRecoveryCredentials() =>
      recoveryKeyService.createRecoveryCredentials();

  void logOut() {
    // TODO: implement logout request
    tokenStorage.removeToken(username: username);
  }
}
