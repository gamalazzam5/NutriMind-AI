import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_response_parser.dart';
import '../../../../core/utils/image_encoding.dart';
import '../models/scanner_response_model.dart';


class ScannerRemoteDataSource {
  ScannerRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ScannerResponseModel> analyzeImage({required String imagePath}) async {
    final response = await _dio.post(
      ApiEndpoints.scanner,
      data: {
        'image': await encodeImageFileToBase64(imagePath),
        'mimeType': resolveImageMimeType(imagePath),
      },
    );
    return ScannerResponseModel.fromJson(parseJsonResponse(response.data));
  }
}
