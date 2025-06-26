import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/owner.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/common/widget/owner_icon.dart';

class FakeLoadingImage extends Image {
  const FakeLoadingImage({super.key})
    : super(image: const FakeLoadingImageProvider());
}

class FakeLoadingImageProvider extends ImageProvider<FakeLoadingImageProvider> {
  const FakeLoadingImageProvider();

  @override
  Future<FakeLoadingImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<FakeLoadingImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    FakeLoadingImageProvider key,
    ImageDecoderCallback decode,
  ) {
    // ローディング状態を維持するため、完了しないImageStreamCompleterを返す
    return OneFrameImageStreamCompleter(
      Future.delayed(
        const Duration(seconds: 1),
        () => ImageInfo(image: _createTestImage()),
      ),
    );
  }

  ui.Image _createTestImage() {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1, 1), Paint());
    return recorder.endRecording().toImageSync(1, 1);
  }
}

void main() {
  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  group('OwnerIcon', () {
    testWidgets('オーナーがnullの場合、デフォルトアイコンが表示される', (tester) async {
      const repository = Repository(
        name: 'repo',
        stargazersCount: 0,
        watchersCount: 0,
        forksCount: 0,
        openIssuesCount: 0,
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: OwnerIcon(repository: repository),
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('オーナーのavatarUrlが空文字の場合、デフォルトアイコンが表示される', (tester) async {
      const repository = Repository(
        name: 'repo',
        stargazersCount: 0,
        watchersCount: 0,
        forksCount: 0,
        openIssuesCount: 0,
        owner: Owner(avatarUrl: ''),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: OwnerIcon(repository: repository),
        ),
      );
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('オーナーのavatarUrlが有効な場合、Image.networkが表示される', (tester) async {
      const repository = Repository(
        name: 'repo',
        stargazersCount: 0,
        watchersCount: 0,
        forksCount: 0,
        openIssuesCount: 0,
        owner: Owner(avatarUrl: 'https://example.com/avatar.png'),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: OwnerIcon(repository: repository),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
