// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_status_stream_provider.c.g.dart';

@Riverpod(keepAlive: true)
Stream<InternetStatus> internetStatusStream(Ref ref) {
  return InternetConnection().onStatusChange;
}
