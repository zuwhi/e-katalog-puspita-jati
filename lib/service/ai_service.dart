import 'package:dio/dio.dart';

class AIService {
  final Dio _dio = Dio();

  Future<String?> sendRequest(String prompt) async {
    String primaryUrl = 'https://apidl.asepharyana.cloud/api/ai/claude';
    String fallbackUrl = 'https://apidl.asepharyana.cloud/api/ai/mistral';

    try {
      final Response response = await _dio.get(
        primaryUrl,
        queryParameters: {'text': prompt},
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );

      return response.data['response'];
    } catch (e) {
      // Log the error for the primary URL
      print('Primary URL failed: $e');

      // Try the fallback URL
      try {
        final Response response = await _dio.get(
          fallbackUrl,
          queryParameters: {'text': prompt},
          options: Options(
            headers: {
              'accept': 'application/json',
            },
          ),
        );

        return response.data['response'];
      } catch (fallbackError) {
        // Log the error for the fallback URL
        print('Fallback URL failed: $fallbackError');
        rethrow;
      }
    }
  }
}
