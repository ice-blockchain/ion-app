import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_posting_provider.g.dart';

@riverpod
class SchedulePosting extends _$SchedulePosting {
  @override
  DateTime build() {
    return DateTime.now();
  }

  set selectedDate(DateTime date) {
    state = date;
  }
}
