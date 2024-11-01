// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/users/ion_users.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets.dart';

/// A user-specific API client that provides access to authentication and wallet services
/// for a specific user. This client is designed to perform operations on behalf of the user
/// represented by this instance.
final class IonApiUserClient {
  /// Creates an instance of [IonApiUserClient] with the specified [auth] and [wallets] services.
  /// Both [auth] and [wallets] are required to interact with the respective user-related APIs.
  const IonApiUserClient({
    required this.auth,
    required this.wallets,
    required this.users,
  });

  /// Provides access to authentication-related operations for the user, such as registering
  /// or logging in.
  final IonAuth auth;

  /// Provides access to wallet-related operations for the user, such as listing and managing
  /// the user's wallets.
  final IonWallets wallets;

  /// Provides access to user-related operations for the user, such as getting user details.
  final IONUsersClient users;
}
