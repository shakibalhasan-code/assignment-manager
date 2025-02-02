import 'dart:convert';
import 'dart:developer';

import '../models/response_model.dart';
import 'package:http/http.dart' as http;


//wrapper class
class ApiService {
  static const String contentTypeJson = 'application/json';

  static Future<ResponseModel> getRequest(String url) async {
    return _makeRequest(
      () => http.get(
        Uri.parse(url),
        headers: _buildHeaders(),
      ),
    );
  }

  static Future<ResponseModel> postRequest(
      String url, Map<String, dynamic> body) async {
    return _makeRequest(
      () => http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: _buildHeaders(),
      ),
    );
  }

  static Map<String, String> _buildHeaders() {
    return {
      'Content-Type': contentTypeJson,
      'Authorization': 'Bearer ',
    };
  }

  static Future<ResponseModel> _makeRequest(
      Future<http.Response> Function() requestFunction) async {
    try {
      final http.Response response = await requestFunction();

      return _handleResponse(response);
    } catch (e) {
      log(e.toString());

      return ResponseModel(
        isSuccess: false,
        statusCode: -1,
        responseBody: '',
        errorMessage: e.toString(),
      );
    }
  }

  static ResponseModel _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      return ResponseModel(
        isSuccess: true,
        statusCode: response.statusCode,
        responseBody: decodedResponse,
      );
    } else {
      return ResponseModel(
        isSuccess: false,
        statusCode: response.statusCode,
        responseBody: '',
      );
    }
  }
}
