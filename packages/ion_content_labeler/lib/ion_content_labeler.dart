import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

typedef LoadModelNative = Void Function(Pointer<Utf8> str);
typedef LoadModel = void Function(Pointer<Utf8> str);

typedef PredictNative = Void Function(Pointer<Utf8> str, Pointer<Utf8> output);
typedef Predict = void Function(Pointer<Utf8> str, Pointer<Utf8> output);

void detectLanguage(String content) async {
  final lib = DynamicLibrary.open('fasttext_predict_simulator.dylib');
  // final loadModelFn = lib.providesSymbol<LoadModelNative, LoadModel>('load_model');
  // final loadModelFn = lib.providesSymbol('load_model');
  // print('loadModelFn $loadModelFn');

  final loadModelFn =
      lib.lookupFunction<LoadModelNative, LoadModel>('load_model'); // Lookup function in library

  ///
  final byteData = await rootBundle.load('assets/language_identification.176.ftz');

  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/language_identification.176.ftz');

  // Write the asset data to a file
  await file
      .writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  final path = file.path;

  ///

  final filenameUtf8 = path.toNativeUtf8();

  loadModelFn(filenameUtf8);
  calloc.free(filenameUtf8);

  final predictFn =
      lib.lookupFunction<PredictNative, Predict>('predict'); // Lookup function in library
  final inputUtf8 = content.toNativeUtf8();
  Pointer<Utf8> outputPrediction = calloc.allocate(20);
  predictFn(inputUtf8, outputPrediction);
  print("Prediction:");
  print(outputPrediction.toDartString());
  calloc.free(inputUtf8);
  calloc.free(outputPrediction);
}
