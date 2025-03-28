// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_content_labeler/src/ffi/fast_text.dart';
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
