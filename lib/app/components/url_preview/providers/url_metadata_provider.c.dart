import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ogp_data_extract/ogp_data_extract.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'url_metadata_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<OgpData?> urlMetadata(Ref ref, String url) async {
  try {
    return await OgpDataExtract.execute(url);
  } catch (e) {
    return null;
  }
}
