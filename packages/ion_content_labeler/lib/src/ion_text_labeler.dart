import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:ion_content_labeler/ion_content_labeler.dart';
import 'package:path_provider/path_provider.dart';

//TODO:load model per instance
class IonTextLabeler {
  Future<TextLabelerResult> detectTextLanguage(String content) async {
    final (:loadModel, :predict) = _loadFastTextLibrarySymbols();
    final modelPath = await _getAssetFilePath(name: 'language_identification.176.ftz');
    loadModel(modelPath);
    final input = _normalizeInput(content);
    return TextLabelerResult(
      input: input,
      labels: predict(input).split(';'),
    );
  }

  Future<TextLabelerResult> detectTextCategory(String content) async {
    final (:loadModel, :predict) = _loadFastTextLibrarySymbols();
    final modelPath = await _getAssetFilePath(name: 'labeling_3.ftz');
    loadModel(modelPath);
    final input = _normalizeInput(content);
    return TextLabelerResult(
      input: input,
      labels: predict(input).split(';'),
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
        Pointer<Utf8> outputPrediction = calloc.allocate(128);
        predictFn(inputUtf8, outputPrediction);
        final prediction = outputPrediction.toDartString();
        calloc.free(inputUtf8);
        calloc.free(outputPrediction);
        return _normalizeOutput(prediction);
      },
    );
  }
}
