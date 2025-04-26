import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_audio_message_provider.c.g.dart';

@riverpod
class ActiveAudioMessage extends _$ActiveAudioMessage {
  @override
  String? build() => null;

  set activeAudioMessage(String? eventMessageId) => state = eventMessageId;
}
