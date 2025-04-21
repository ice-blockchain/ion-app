// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/uuid/uuid.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

///
/// Generates a new output path for a compressed file.
///
Future<String> generateOutputPath({String extension = 'webp'}) async {
  // Get a platform-independent temporary directory
  final tempDir = await getApplicationCacheDirectory();

  // Generate a new output filename
  final uuid = generateUuid();
  final outputFileName = 'compressed_$uuid.$extension';

  // Join temp directory with the generated filename
  final outputPath = path.join(tempDir.path, outputFileName);
  return outputPath;
}
