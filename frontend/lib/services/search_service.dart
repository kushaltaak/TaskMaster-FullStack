class SearchService {
  static List<Map<String, dynamic>> searchTasks(
      List<Map<String, dynamic>> tasks,
      String query,
      ) {
    if (query.isEmpty) {
      return tasks;
    }

    return tasks.where((task) {
      return task["title"]
          .toString()
          .toLowerCase()
          .contains(
        query.toLowerCase(),
      );
    }).toList();
  }
}