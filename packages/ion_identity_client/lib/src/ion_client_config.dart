/// A configuration class for the Ion API client, containing the necessary
/// identifiers and origin information required to initialize the client.
class IonClientConfig {
  /// Creates an instance of [IonClientConfig] with the specified [appId], [orgId], and [origin].
  /// These parameters are essential for configuring the Ion API client.
  IonClientConfig({
    required this.appId,
    required this.orgId,
    required this.origin,
  });

  /// The application identifier used to uniquely identify the app within the Ion API.
  final String appId;

  /// The organization identifier associated with the app, used for managing and scoping
  /// resources within the Ion API.
  final String orgId;

  /// The origin URL from which the requests are made. This is used for validating
  /// and securing API requests.
  final String origin;

  @override
  String toString() => 'IonClientConfig(appId: $appId, orgId: $orgId, origin: $origin)';
}
