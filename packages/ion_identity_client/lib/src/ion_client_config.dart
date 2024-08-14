class IonClientConfig {
  IonClientConfig({
    required this.appId,
    required this.orgId,
    required this.origin,
  });

  final String appId;
  final String orgId;
  final String origin;

  @override
  String toString() => 'IonClientConfig(appId: $appId, orgId: $orgId, origin: $origin)';
}
