import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

abstract class ModelFile {
  const ModelFile({required this.name});

  final String name;

  Future<void> preload();

  Future<File> load() async {
    final file = await _file;
    if (await file.exists()) {
      return file;
    }
    await preload();
    return file;
  }

  Future<File> get _file async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$name');
  }
}

class AssetModelFile extends ModelFile {
  const AssetModelFile({required super.name});

  @override
  Future<void> preload() async {
    final byteData = await rootBundle.load('packages/ion_content_labeler/assets/$name');
    (await _file)
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}

class NetworkModelFile extends ModelFile {
  const NetworkModelFile({required super.name, required this.url});

  final String url;

  @override
  Future<void> preload() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download bundle');
    }

    (await _file).writeAsBytes(response.bodyBytes);
  }
}
