import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
Future<SyncTransactionsService> syncTransactionsService(Ref ref) async {
  return SyncTransactionsService();
}

class SyncTransactionsService {}
