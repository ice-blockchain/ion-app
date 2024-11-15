import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_pointer.freezed.dart';

@freezed
class EventPointer with _$EventPointer {
  const factory EventPointer({
    required String eventId,
    required String pubkey,
  }) = _EventPointer;
}
