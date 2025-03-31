import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

abstract class ModelFile {
  Future<String> getPath();
}

class AssetModelFile implements ModelFile {
  const AssetModelFile({required this.name});

  final String name;

  @override
  Future<String> getPath() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$name');
    if (await file.exists()) {
      return file.path;
    }

    final byteData = await rootBundle.load('packages/ion_content_labeler/assets/$name');
    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }
}

class NetworkModelFile implements ModelFile {
  const NetworkModelFile({required this.name, required this.url});

  final String name;
  final String url;

  @override
  Future<String> getPath() async {
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/$name');
    if (await file.exists()) {
      return file.path;
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download bundle');
    }

    await file.writeAsBytes(response.bodyBytes);

    return file.path;
  }
}
