import 'package:dio/dio.dart';

class AIService {
  final Dio _dio = Dio();

  Future<String?> sendRequest(String prompt) async {
    String url = 'https://mr-apis.com/api/ai/geminitext';

    try {
      final Response response = await _dio.get(
        url,
        queryParameters: {'prompt': prompt},
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );

      return response.data['message'];
    } catch (e) {
      rethrow;
    }
  }
}
