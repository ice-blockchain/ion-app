import 'package:flutter_test/flutter_test.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/hooks/use_video_controller_hook.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

void main() {
  group('initializeVideoController', () {
    late MockVideoPlayerController mockController;

    setUp(() {
      mockController = MockVideoPlayerController();
      when(() => mockController.initialize()).thenAnswer((_) async => {});
      when(() => mockController.setLooping(any())).thenAnswer((_) async => {});
      when(() => mockController.play()).thenAnswer((_) async => {});
    });

    test('initializes, sets looping, and plays video', () async {
      await initializeVideoController(mockController);

      verify(() => mockController.initialize()).called(1);
      verify(() => mockController.setLooping(true)).called(1);
      verify(() => mockController.play()).called(1);
    });
  });
}
