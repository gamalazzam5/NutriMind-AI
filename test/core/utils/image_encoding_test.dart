import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimind/core/utils/image_encoding.dart';

void main() {
  group('resolveImageMimeType', () {
    test('resolves known extensions', () {
      expect(resolveImageMimeType('photo.png'), 'image/png');
      expect(resolveImageMimeType('photo.PNG'), 'image/png');
      expect(resolveImageMimeType('photo.webp'), 'image/webp');
      expect(resolveImageMimeType('photo.heic'), 'image/heic');
      expect(resolveImageMimeType('photo.jpg'), 'image/jpeg');
      expect(resolveImageMimeType('photo.jpeg'), 'image/jpeg');
    });

    test('defaults to image/jpeg for unknown extensions', () {
      expect(resolveImageMimeType('photo.bin'), 'image/jpeg');
    });
  });

  group('encodeImageFileToBase64', () {
    test('reads a file and returns its base64 contents', () async {
      final bytes = [1, 2, 3, 4, 5];
      final file = File(
        '${Directory.systemTemp.path}/nutrimind_image_encoding_test.bin',
      );
      await file.writeAsBytes(bytes);
      addTearDown(() => file.delete());

      final result = await encodeImageFileToBase64(file.path);

      expect(result, base64Encode(bytes));
    });
  });
}
