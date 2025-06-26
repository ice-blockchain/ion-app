// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll_data.f.freezed.dart';
part 'poll_data.f.g.dart';

@freezed
class PollData with _$PollData {
  const factory PollData({
    required String type, // "single" or "multiple"
    required int ttl, // Unix timestamp for expiration (seconds since epoch)
    required String title, // Poll question
    required List<String> options, // Poll options
  }) = _PollData;

  const PollData._();

  factory PollData.fromJson(Map<String, dynamic> json) => _$PollDataFromJson(json);

  static PollData? fromTag(List<String> tag) {
    if (tag.isEmpty || tag[0] != 'poll') {
      return null;
    }

    var type = 'single';
    var ttl = 0;
    var title = '';
    var options = <String>[];

    for (var i = 1; i < tag.length; i++) {
      final param = tag[i];
      if (param.startsWith('type ')) {
        type = param.substring(5);
      } else if (param.startsWith('ttl ')) {
        ttl = int.tryParse(param.substring(4)) ?? 0;
      } else if (param.startsWith('title ')) {
        title = param.substring(6);
      } else if (param.startsWith('options ')) {
        final optionsJson = param.substring(8);
        final decoded = jsonDecode(optionsJson);
        if (decoded is List) {
          options = decoded.cast<String>();
        }
      }
    }

    if (options.isEmpty) {
      return null;
    }

    return PollData(
      type: type,
      ttl: ttl,
      title: title,
      options: options,
    );
  }

  List<String> toTag() {
    return [
      'poll',
      'type $type',
      'ttl $ttl',
      'title $title',
      'options ${jsonEncode(options)}',
    ];
  }

  List<List<String>> toTags() {
    return [toTag()];
  }

  DateTime? get closingTime {
    if (ttl <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ttl * 1000);
  }

  bool get isClosed {
    if (ttl <= 0) return false; // Never expires
    final currentTime = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    return currentTime > ttl;
  }
}
