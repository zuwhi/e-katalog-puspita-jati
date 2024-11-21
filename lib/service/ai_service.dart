import 'package:dio/dio.dart';

class AIService {
  final Dio _dio = Dio();

  Future<String?> sendRequest(String prompt) async {
    String url = 'https://apidl.asepharyana.cloud/api/ai/gemini';

    try {
      final Response response = await _dio.get(
        url,
        queryParameters: {'text': prompt},
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );
  
      return response.data['answer'];
    } catch (e) {
     
      rethrow;
    }
  }
}
