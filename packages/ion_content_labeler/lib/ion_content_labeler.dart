// ignore_for_file: public_member_api_docs, sort_constructors_first
// SPDX-License-Identifier: ice License 1.0

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<PredictResult> detectTextLanguage(String content) async {
  final (:loadModel, :predict) = _loadFastTextLibrarySymbols();
  final modelPath = await _getAssetFilePath(name: 'language_identification.176.ftz');
  loadModel(modelPath);
  final input = _normalizeInput(content);
  return PredictResult(
    input: input,
    predictions: predict(input).split(';'),
  );
}

Future<PredictResult> detectTextCategory(String content) async {
  final (:loadModel, :predict) = _loadFastTextLibrarySymbols();
  final modelPath = await _getAssetFilePath(name: 'labeling_2.ftz');
  loadModel(modelPath);
  final input = _normalizeInput(content);
  return PredictResult(
    input: input,
    predictions: predict(input).split(';'),
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

String _normalizeOutput(String output) {
  return output.replaceFirst('__label__', '');
}

String _normalizeInput(String input) {
  return input.replaceAll('\n', ' ').replaceAll(RegExp(r'[^\w\s#\$]'), '').toLowerCase().trim();
}

({
  void Function(String path) loadModel,
  String Function(String content) predict,
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
      Pointer<Utf8> outputPrediction = calloc.allocate(20);
      predictFn(inputUtf8, outputPrediction);
      final prediction = outputPrediction.toDartString();
      calloc.free(inputUtf8);
      calloc.free(outputPrediction);
      return _normalizeOutput(prediction);
    },
  );
}

class PredictResult {
  final List<String> predictions;
  final String input;

  PredictResult({
    required this.predictions,
    required this.input,
  });

  @override
  bool operator ==(covariant PredictResult other) {
    if (identical(this, other)) return true;

    return listEquals(other.predictions, predictions) && other.input == input;
  }

  @override
  int get hashCode => predictions.hashCode ^ input.hashCode;

  @override
  String toString() => 'PredictResult(predictions: $predictions, input: $input)';

  PredictResult copyWith({
    List<String>? predictions,
    String? input,
  }) {
    return PredictResult(
      predictions: predictions ?? this.predictions,
      input: input ?? this.input,
    );
  }
}
