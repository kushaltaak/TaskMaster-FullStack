import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TaskService {

  static const String baseUrl =
      "http://10.0.2.2:5000";

  static Future<void> createTask({
    required String title,
    required String category,
    required String dueDate,
  }) async {

    String? token =
    await AuthService.getToken();

    print("CREATE TOKEN:");
    print(token);

    final response =
    await http.post(
      Uri.parse(
        "$baseUrl/api/tasks",
      ),
      headers: {
        "Content-Type":
        "application/json",
        "Authorization":
        "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "category": category,
        "dueDate": dueDate,
      }),
    );

    print("CREATE RESPONSE:");
    print(response.body);
  }

  static Future<void> deleteTask(
      String taskId,
      ) async {

    String? token =
    await AuthService.getToken();

    final response =
    await http.delete(
      Uri.parse(
        "$baseUrl/api/tasks/$taskId",
      ),
      headers: {
        "Authorization":
        "Bearer $token",
      },
    );

    print(response.body);
  }

  static Future<void> updateTask(
      String taskId,
      ) async {

    String? token =
    await AuthService.getToken();

    final response =
    await http.put(
      Uri.parse(
        "$baseUrl/api/tasks/$taskId",
      ),
      headers: {
        "Authorization":
        "Bearer $token",
      },
    );

    print(response.body);
  }

  static Future<void> editTask({
    required String taskId,
    required String title,
    required String category,
    required String dueDate,
  }) async {

    String? token =
    await AuthService.getToken();

    final response =
    await http.put(
      Uri.parse(
        "$baseUrl/api/tasks/edit/$taskId",
      ),
      headers: {
        "Content-Type":
        "application/json",
        "Authorization":
        "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "category": category,
        "dueDate": dueDate,
      }),
    );

    print(response.body);
  }


  static Future<List<dynamic>>
  getTasks() async {

    String? token =
    await AuthService.getToken();

    print("GET TOKEN:");
    print(token);

    final response =
    await http.get(
      Uri.parse(
        "$baseUrl/api/tasks",
      ),
      headers: {
        "Authorization":
        "Bearer $token",
      },
    );

    print("GET RESPONSE:");
    print(response.body);

    return jsonDecode(
      response.body,
    );
  }
}

