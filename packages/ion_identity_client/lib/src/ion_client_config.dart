// SPDX-License-Identifier: ice License 1.0

/// A configuration class for the Ion API client, containing the necessary
/// identifiers and origin information required to initialize the client.
class IonClientConfig {
  /// Creates an instance of [IonClientConfig] with the specified [appId] and [origin].
  /// These parameters are essential for configuring the Ion API client.
  IonClientConfig({
    required this.appId,
    required this.origin,
  });

  /// The application identifier used to uniquely identify the app within the Ion API.
  final String appId;

  /// The origin URL from which the requests are made. This is used for validating
  /// and securing API requests.
  final String origin;

  @override
  String toString() => 'IonClientConfig(appId: $appId, origin: $origin)';
}
