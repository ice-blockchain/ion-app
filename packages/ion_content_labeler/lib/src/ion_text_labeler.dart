// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ion_content_labeler/ion_content_labeler.dart';

enum TextLabelerType {
  language,
  category,
}

//TODO:add downloading models, use predict in isolate
class IonTextLabeler {
  IonTextLabeler._(this._loadModel, this._predict);

  final void Function(String path) _loadModel;

  final List<Label> Function(String content) _predict;

  static Future<IonTextLabeler> create() async {
    final (:loadModel, :predict) = _loadFastTextLibrarySymbols();
    return IonTextLabeler._(loadModel, predict);
  }

  Future<TextLabelerResult> detect(String input, {required TextLabelerType type}) async {
    //TODO:add abstract Model class that will resolve it's path
    final modelName = switch (type) {
      TextLabelerType.language => 'language_identification.176.ftz',
      TextLabelerType.category => 'labeling_3.ftz',
    };
    final modelPath = await _getAssetFilePath(name: modelName);
    _loadModel(modelPath);

    final normalizedInput = _normalizeInput(input);
    return TextLabelerResult(
      input: normalizedInput,
      labels: _predict(input).map(_normalizeLabel).toList(),
    );
  }

  static Future<String> _getAssetFilePath({required String name}) async {
    final byteData = await rootBundle.load('assets/$name');

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$name');

    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }

  static DynamicLibrary _loadFastTextLibrary() {
    if (Platform.isIOS) {
      return DynamicLibrary.open('fasttext_predict.framework/fasttext_predict');
    } else if (Platform.isAndroid) {
      return DynamicLibrary.open('libfasttext_predict.so');
    } else {
      throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
    }
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

  //TODO: make those non static
  static ({
    void Function(String path) loadModel,
    List<Label> Function(String content) predict,
  }) _loadFastTextLibrarySymbols() {
    final lib = _loadFastTextLibrary();
    return (
      loadModel: (String path) {
        final filenameUtf8 = path.toNativeUtf8();
        final loadModelFn =
            lib.lookupFunction<Void Function(Pointer<Utf8> str), void Function(Pointer<Utf8> str)>(
                'load_model');
        loadModelFn(filenameUtf8);
        calloc.free(filenameUtf8);
      },
      predict: (String input) {
        final predictFn = lib.lookupFunction<Void Function(Pointer<Utf8> str, Pointer<Utf8> output),
            void Function(Pointer<Utf8> str, Pointer<Utf8> output)>('predict');
        final inputUtf8 = input.toNativeUtf8();
        Pointer<Utf8> outputPrediction = calloc.allocate(256);
        predictFn(inputUtf8, outputPrediction);
        final predictions = outputPrediction.toDartString();
        calloc.free(inputUtf8);
        calloc.free(outputPrediction);
        return (jsonDecode(predictions) as List<dynamic>)
            .map((prediction) => Label.fromMap(prediction))
            .toList();
      },
    );
  }
}
