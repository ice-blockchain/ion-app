// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ion_content_labeler/ion_content_labeler.dart';

//TODO:load model per instance, add downloading models, use predict in isolate
class IonTextLabeler {
  Future<TextLabelerResult> detectTextLanguage(String content) async {
    final (:loadModel, :predict) = _loadFastTextLibrarySymbols();
    final modelPath = await _getAssetFilePath(name: 'language_identification.176.ftz');
    loadModel(modelPath);
    final input = _normalizeInput(content);
    return TextLabelerResult(
      input: input,
      labels: predict(input),
    );
  }

  Future<TextLabelerResult> detectTextCategory(String content) async {
    final (:loadModel, :predict) = _loadFastTextLibrarySymbols();
    final modelPath = await _getAssetFilePath(name: 'labeling_3.ftz');
    loadModel(modelPath);
    final input = _normalizeInput(content);
    return TextLabelerResult(
      input: input,
      labels: predict(input),
    );
  }

  Future<String> _getAssetFilePath({required String name}) async {
    final byteData = await rootBundle.load('assets/$name');

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$name');

    await file
        .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }

  DynamicLibrary _loadFastTextLibrary() {
    if (Platform.isIOS) {
      return DynamicLibrary.open('fasttext_predict.framework/fasttext_predict');
    } else if (Platform.isAndroid) {
      return DynamicLibrary.open('libfasttext_predict.so');
    } else {
      throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
    }
  }

  Label _normalizeLabel(Label label) {
    return label.copyWith(name: label.name.replaceFirst('__label__', ''));
  }

  String _normalizeInput(String input) {
    return input
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'[^\p{L}\s]', unicode: true), '')
        .toLowerCase()
        .trim();
  }

  ({
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
            .map((prediction) => _normalizeLabel(Label.fromMap(prediction)))
            .toList();
      },
    );
  }
}
