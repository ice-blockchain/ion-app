// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/services/providers/bech32/bech32_service.c.dart';
import 'package:ion/app/services/providers/ion_connect/ion_connect_protocol_identifier_type.dart';
import 'package:ion/app/services/providers/ion_connect/ion_connect_uri_identifier_service.c.dart';
import 'package:mocktail/mocktail.dart';

class MockBech32Service extends Mock implements Bech32Service {}

void main() {
  late IonConnectUriIdentifierService service;
  late MockBech32Service mockBech32Service;

  setUpAll(() {
    registerFallbackValue(IonConnectProtocolIdentifierType.note);
  });

  setUp(() {
    mockBech32Service = MockBech32Service();
    service = IonConnectUriIdentifierService(
      bech32Service: mockBech32Service,
    );
  });

  group('decode', () {
    test('throws when trying to decode shareable identifier', () {
      when(() => mockBech32Service.decode(any())).thenReturn(
        (prefix: IonConnectProtocolIdentifierType.nprofile, data: 'test'),
      );

      expect(
        () => service.decode(payload: 'nprofile1...'),
        throwsException,
      );
    });

    test('decodes non-shareable identifier', () {
      when(() => mockBech32Service.decode(any())).thenReturn(
        (prefix: IonConnectProtocolIdentifierType.note, data: 'test'),
      );

      final result = service.decode(payload: 'note1asdadasasdasdadasd');
      expect(result.prefix, IonConnectProtocolIdentifierType.note);
    });
  });

  group('encode', () {
    test('throws when trying to encode shareable identifier', () {
      expect(
        () => service.encode(
          prefix: IonConnectProtocolIdentifierType.nprofile,
          data: 'test',
        ),
        throwsException,
      );
    });

    test('encodes non-shareable identifier', () {
      when(() => mockBech32Service.encode(any(), any())).thenReturn('note1test');

      final result = service.encode(
        prefix: IonConnectProtocolIdentifierType.note,
        data: 'test',
      );
      expect(result.startsWith('note1'), isTrue);
    });
  });

  group('encodeShareableIdentifiers', () {
    test('throws when trying to encode non-shareable identifier', () {
      expect(
        () => service.encodeShareableIdentifiers(
          prefix: IonConnectProtocolIdentifierType.note,
          special: 'test',
        ),
        throwsException,
      );
    });

    test('encodes nprofile with all fields', () {
      when(() => mockBech32Service.encode(any(), any(), length: any(named: 'length')))
          .thenReturn('nprofile1test');

      final result = service.encodeShareableIdentifiers(
        prefix: IonConnectProtocolIdentifierType.nprofile,
        special: '477318cfb5427b9cfc66a9fa376150c1ddbc62115ae27cef72417eb959691396',
      );
      expect(result.startsWith('nprofile1'), isTrue);
    });
  });

  group('decodeShareableIdentifiers', () {
    test('returns null for null input', () {
      final result = service.decodeShareableIdentifiers(payload: null);
      expect(result, isNull);
    });

    test('decodes nprofile with all fields', () {
      // Mocking the bech32Service to return a valid decoded result
      when(() => mockBech32Service.decode(any(), length: any(named: 'length'))).thenReturn(
        (
          prefix: IonConnectProtocolIdentifierType.nprofile,
          data: '0020477318cfb5427b9cfc66a9fa376150c1ddbc62115ae27cef72417eb959691396'
        ),
      );

      final result = service.decodeShareableIdentifiers(
        payload: 'nprofile1test',
      );

      // Verifying the result
      expect(result, isNotNull);
      expect(result?.prefix, IonConnectProtocolIdentifierType.nprofile);
      expect(result?.special, '477318cfb5427b9cfc66a9fa376150c1ddbc62115ae27cef72417eb959691396');
    });

    test('throws on invalid input', () {
      when(() => mockBech32Service.decode(any(), length: any(named: 'length')))
          .thenThrow(Exception('Invalid input'));

      expect(
        () => service.decodeShareableIdentifiers(payload: 'invalid'),
        throwsException,
      );
    });
  });
}
