import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/providers/video_player_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

ProviderContainer createContainer({
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  return container;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  test('videoControllerProvider initializes and plays video', () async {
    final container = createContainer(
      overrides: [
        videoControllerProvider.overrideWith((ref) async {
          await mockController.initialize();
          await mockController.setLooping(true);
          await mockController.play();
          return mockController;
        }),
      ],
    );

    final controller = await container.read(videoControllerProvider.future);

    expect(controller, isA<VideoPlayerController>());
    expect(controller.value.isInitialized, isTrue);
    expect(controller.value.isLooping, isTrue);
    expect(controller.value.isPlaying, isTrue);

    verify(() => mockController.initialize()).called(1);
    verify(() => mockController.setLooping(true)).called(1);
    verify(() => mockController.play()).called(1);
  });
}
