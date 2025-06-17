import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LimitedConcurrentHttpFileService extends HttpFileService {
  LimitedConcurrentHttpFileService({
    required int concurrentFetches,
    super.httpClient,
  }) : _concurrentFetches = concurrentFetches;

  final int _concurrentFetches;

  @override
  int get concurrentFetches => _concurrentFetches;
}
