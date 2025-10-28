import 'dart:convert';
import 'package:http/http.dart' as http;
import 'i_get_all_tasks_api_service.dart';

class GetAllTasksApiService implements IGetAllTasksApiService {
  final String baseUrl = 'https://dummyjson.com';

  @override
  Future<Map<String, dynamic>> getAllTasks() async {
    final res = await http.get(Uri.parse('$baseUrl/todos'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to fetch tasks: ${res.statusCode}');
    }
  }
}
