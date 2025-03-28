// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ion_content_labeler/ion_content_labeler.dart';

enum TextLabelerType {
  language(AssetClassificationModel(name: 'language_identification.176.ftz')),
  category(NetworkClassificationModel(
    name: 'labeling_v3',
    url:
        'https://github.com/ice-blockchain/ion-app/raw/063772ec0dd75fac8946b2f33fb4ea33d04308aa/assets/labeling_3.ftz',
  ));

  final ClassificationModel model;

  const TextLabelerType(this.model);
}

//TODO:use predict in isolate, add custom exceptions
class IonTextLabeler {
  IonTextLabeler._(this._lib);

  final FastText _lib;

  static Future<IonTextLabeler> create(TextLabelerType type) async {
    final lib = FastText();
    final modelPath = await type.model.getPath();
    lib.loadModel(modelPath);
    return IonTextLabeler._(lib);
  }

  Future<TextLabelerResult> detect(String input, {int count = 3}) async {
    final normalizedInput = _normalizeInput(input);
    final predictionsJson = _lib.predict(input, k: count);
    final labels = (jsonDecode(predictionsJson) as List<dynamic>)
        .map((prediction) => _normalizeLabel(Label.fromMap(prediction)))
        .toList();
    return TextLabelerResult(
      input: normalizedInput,
      labels: labels,
    );
  }

  void dispose() {
    _lib.dispose();
  }

  static Label _normalizeLabel(Label label) {
    return label.copyWith(name: label.name.replaceFirst('__label__', ''));
  }

  String _normalizeInput(String input) {
    return input
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'[^\p{L}\s]', unicode: true), '')
        .toLowerCase()
        .trim();
  }
}

class FastText {
  final int _handle;

  final void Function(int handle, Pointer<Utf8> filename) _loadModel;
  final void Function(int handle, Pointer<Utf8> input, int k, Pointer<Utf8> out, int outSize)
      _predict;
  final void Function(int handle) _destroyInstance;

  FastText._(this._handle, this._loadModel, this._predict, this._destroyInstance);

  factory FastText() {
    final lib = _loadLibrary();

    final createInstance = lib.lookupFunction<Uint64 Function(), int Function()>('create_instance');

    final loadModel = lib.lookupFunction<Void Function(Uint64 handle, Pointer<Utf8> filename),
        void Function(int handle, Pointer<Utf8> filename)>('load_model');

    final predict = lib.lookupFunction<
        Void Function(
            Uint64 handle, Pointer<Utf8> input, Int32 k, Pointer<Utf8> out, Uint64 outSize),
        void Function(
            int handle, Pointer<Utf8> input, int k, Pointer<Utf8> out, int outSize)>('predict');

    final destroyInstance =
        lib.lookupFunction<Void Function(Uint64 handle), void Function(int handle)>(
            'destroy_instance');

    final handle = createInstance();
    if (handle == 0) {
      throw Exception('Failed to create FastText instance');
    }

    return FastText._(
      handle,
      loadModel,
      predict,
      destroyInstance,
    );
  }

  void loadModel(String modelPath) {
    final modelPathPtr = modelPath.toNativeUtf8();
    try {
      _loadModel(_handle, modelPathPtr);
    } finally {
      calloc.free(modelPathPtr);
    }
  }

  String predict(String text, {int k = 3}) {
    final textPtr = text.toNativeUtf8();
    final outPtr = calloc.allocate<Utf8>(512);

    try {
      _predict(_handle, textPtr, k, outPtr, 512);
      return outPtr.toDartString();
    } finally {
      calloc.free(textPtr);
      calloc.free(outPtr);
    }
  }

  void dispose() {
    _destroyInstance(_handle);
  }

  static DynamicLibrary _loadLibrary() {
    if (Platform.isIOS) {
      return DynamicLibrary.open('fasttext_predict.framework/fasttext_predict');
    } else if (Platform.isAndroid) {
      return DynamicLibrary.open('libfasttext_predict.so');
    } else {
      throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
    }
  }
}

abstract class ClassificationModel {
  Future<String> getPath();
}

class AssetClassificationModel implements ClassificationModel {
  const AssetClassificationModel({required this.name});

  final String name;

  @override
  Future<String> getPath() async {
    final directory = await getApplicationCacheDirectory();
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

class NetworkClassificationModel implements ClassificationModel {
  const NetworkClassificationModel({required this.name, required this.url});

  final String name;
  final String url;

  @override
  Future<String> getPath() async {
    final directory = await getApplicationCacheDirectory();
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
