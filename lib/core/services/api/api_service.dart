import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const _defaultHeaders = {'Content-Type': 'application/json'};
  static const _timeout = Duration(seconds: 15);

  static dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return null;
      try {
        return jsonDecode(res.body);
      } catch (_) {
        return res.body;
      }
    }
    throw HttpException('Request failed (${res.statusCode}): ${res.body}');
  }

  static Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final res = await http.get(Uri.parse(url), headers: headers).timeout(_timeout);
    return _handleResponse(res);
  }

  static Future<dynamic> post(String url, {Map<String, String>? headers, Object? body}) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {..._defaultHeaders, ...?headers},
      body: body is String ? body : jsonEncode(body),
    ).timeout(_timeout);
    return _handleResponse(res);
  }

  static Future<dynamic> put(String url, {Map<String, String>? headers, Object? body}) async {
    final res = await http.put(
      Uri.parse(url),
      headers: {..._defaultHeaders, ...?headers},
      body: body is String ? body : jsonEncode(body),
    ).timeout(_timeout);
    return _handleResponse(res);
  }

  static Future<dynamic> patch(String url, {Map<String, String>? headers, Object? body}) async {
    final res = await http.patch(
      Uri.parse(url),
      headers: {..._defaultHeaders, ...?headers},
      body: body is String ? body : jsonEncode(body),
    ).timeout(_timeout);
    return _handleResponse(res);
  }

  static Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    final res = await http.delete(Uri.parse(url), headers: headers).timeout(_timeout);
    return _handleResponse(res);
  }
}
