import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String taskKey = "tasks";
  static const String themeKey = "theme";

  static Future<void> saveTasks(
      List<Map<String, dynamic>> tasks) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setString(
      taskKey,
      jsonEncode(tasks),
    );
  }

  static Future<List<Map<String, dynamic>>>
  loadTasks() async {

    final prefs =
    await SharedPreferences.getInstance();

    final taskJson =
    prefs.getString(taskKey);

    if (taskJson == null) {
      return [];
    }

    return List<Map<String, dynamic>>.from(
      jsonDecode(taskJson),
    );
  }

  static Future<void> saveTheme(
      bool isDarkMode) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setBool(
      themeKey,
      isDarkMode,
    );
  }

  static Future<bool> loadTheme() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(themeKey) ?? false;
  }
}