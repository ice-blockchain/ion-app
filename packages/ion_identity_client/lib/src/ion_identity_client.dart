// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/coins/ion_identity_coins.dart';
import 'package:ion_identity_client/src/users/ion_identity_users.dart';
import 'package:ion_identity_client/src/wallets/ion_identity_wallets.dart';

/// A user-specific API client that provides access to authentication and wallet services
/// for a specific user. This client is designed to perform operations on behalf of the user
/// represented by this instance.
final class IONIdentityClient {
  /// Creates an instance of [IONIdentityClient] with the specified [auth] and [wallets] services.
  /// Both [auth] and [wallets] are required to interact with the respective user-related APIs.
  const IONIdentityClient({
    required this.auth,
    required this.wallets,
    required this.users,
    required this.coins,
  });

  /// Provides access to authentication-related operations for the user, such as registering
  /// or logging in.
  final IONIdentityAuth auth;

  /// Provides access to wallet-related operations for the user, such as listing and managing
  /// the user's wallets.
  final IONIdentityWallets wallets;

  /// Provides access to user-related operations for the user, such as getting user details.
  final IONIdentityUsers users;

  /// Provides access to coins-related operations, such as getting coins information.
  final IONIdentityCoins coins;
}
