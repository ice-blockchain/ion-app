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
      when(() => mockController.value).thenReturn(
        const VideoPlayerValue(
          duration: Duration.zero,
          isInitialized: true,
          isPlaying: true,
          isLooping: true,
        ),
      );
    });

    test('initializes, sets looping, and plays video', () async {
      await initializeVideoController(mockController);

      expect(mockController, isA<VideoPlayerController>());
      expect(mockController.value.isInitialized, isTrue);
      expect(mockController.value.isLooping, isTrue);
      expect(mockController.value.isPlaying, isTrue);

      verify(() => mockController.initialize()).called(1);
      verify(() => mockController.setLooping(true)).called(1);
      verify(() => mockController.play()).called(1);
    });
  });
}
