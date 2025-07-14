import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_agent.f.freezed.dart';

@freezed
class UserAgent with _$UserAgent {
  const factory UserAgent({
    required List<UserAgentComponent> components,
  }) = _UserAgent;

  @override
  String toString() => components.map((component) => component.toString()).join(' ');
}

@freezed
class UserAgentComponent with _$UserAgentComponent {
  const factory UserAgentComponent({
    required String name,
    required String version,
  }) = _UserAgentComponent;

  @override
  String toString() => '$name/$version';
}
