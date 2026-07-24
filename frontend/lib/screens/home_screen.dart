import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/search_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../services/task_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> loadData() async {

    final loadedTasks =
    await StorageService.loadTasks();

    final savedTheme =
    await StorageService.loadTheme();

    setState(() {
      if (loadedTasks.isNotEmpty) {
        tasks = loadedTasks;
      }

      isDarkMode = savedTheme;
    });
  }

  bool isDarkMode = false ;

  String searchQuery = "";

  List<Map<String, dynamic>> tasks = [ ];





  Future<void> addTask(
      String title,
      String category,
      String dueDate,
      ) async {

    await TaskService.createTask(
      title: title,
      category: category,
      dueDate: dueDate,
    );

    await fetchTasks();
  }




  Future<void> toggleTask(
      String taskId,
      ) async {

    await TaskService.updateTask(
      taskId,
    );

    await fetchTasks();
  }




  void deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text(
            "Are you sure you want to delete this task?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  tasks.removeAt(index);
                });
                StorageService.saveTasks(tasks);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }




  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });

    StorageService.saveTheme(isDarkMode);
  }





  Future<void> fetchTasks() async {
    try {
      final tasksFromApi =
      await TaskService.getTasks();

      setState(() {
        tasks = List<Map<String, dynamic>>.from(
          tasksFromApi,
        );
      });

      print(tasks);
    } catch (e) {
      print(e);
    }
  }


  Future<void> showEditTaskDialog(
      Map<String, dynamic> task,
      ) async {

    final titleController =
    TextEditingController(
      text: task["title"],
    );

    final categoryController =
    TextEditingController(
      text: task["category"],
    );

    final dueDateController =
    TextEditingController(
      text: task["dueDate"],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Task",
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [

                TextField(
                  controller:
                  titleController,
                  decoration:
                  const InputDecoration(
                    labelText: "Title",
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                TextField(
                  controller:
                  categoryController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Category",
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                TextField(
                  controller:
                  dueDateController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Due Date",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child:
              const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                await TaskService.editTask(
                  taskId:
                  task["_id"],
                  title:
                  titleController.text,
                  category:
                  categoryController.text,
                  dueDate:
                  dueDateController.text,
                );

                await fetchTasks();

                Navigator.pop(
                  context,
                );
              },
              child:
              const Text("Save"),
            ),
          ],
        );
      },
    );
  }







  void showAddTaskDialog() {
    TextEditingController controller =
    TextEditingController();

    String selectedCategory = "Personal";
    String selectedDueDate = "No Date";

    Future<void> pickDate(
        StateSetter setDialogState) async {

      DateTime? pickedDate =
      await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );

      if (pickedDate != null) {
        setDialogState(() {
          selectedDueDate =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          isDarkMode
              ? const Color(0xFF1E1E1E)
              : Colors.white,

          title: Text(
            "Add New Task",
            style: TextStyle(
              color: isDarkMode
                  ? Colors.white
                  : Colors.black,
            ),
          ),

          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  TextField(
                    controller: controller,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter task title",
                      hintStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.white54
                            : Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Category",
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Study",
                        child: Text("📚 Study"),
                      ),
                      DropdownMenuItem(
                        value: "Work",
                        child: Text("💼 Work"),
                      ),
                      DropdownMenuItem(
                        value: "Personal",
                        child: Text("🏠 Personal"),
                      ),
                      DropdownMenuItem(
                        value: "Fitness",
                        child: Text("🏋️ Fitness"),
                      ),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),

                  InkWell(
                    onTap: () {
                      pickDate(setDialogState);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              selectedDueDate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
            onPressed: () async {

        if (controller.text
            .trim()
            .isEmpty) {
        return;
        }

        await addTask(
        controller.text.trim(),
        "Personal",
        DateTime.now()
            .toString()
            .split(" ")[0],
        );

        Navigator.pop(
        context,
        );
        },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }






  @override
  void initState() {
    super.initState();
    // loadData();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks =
        tasks.where((task) => task["completed"]).length;

    double progress = tasks.isEmpty ? 0 : completedTasks /tasks.length ;

    final filteredTasks =
    SearchService.searchTasks(
      tasks,
      searchQuery,
    );

    return Scaffold(
      backgroundColor:
      isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
        isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,

        centerTitle: true,

        title: Text(
          "Task Master",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode
                  ? Colors.white
                  : Colors.black,
            ),
            onSelected: (value) async {

              if (value == "theme") {
                toggleTheme();
              }

              if (value == "clear") {
                setState(() {
                  tasks.clear();
                });

                StorageService.saveTasks(tasks);
              }

              if (value == "logout") {

                await AuthService.logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                      (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "theme",
                child: Row(
                  children: [
                    Icon(
                      isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isDarkMode
                          ? "Light Mode"
                          : "Dark Mode",
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "logout",
                child: Row(
                  children: const [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Kushal 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color:
                isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Manage your tasks efficiently",
              style: TextStyle(
                color:
                isDarkMode
                    ? Colors.white70
                    : Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF6366F1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${tasks.length} Tasks",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    completedTasks == 0
                        ? "🚀 Let's get started!"
                        : "$completedTasks Completed",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor:
                      const AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    completedTasks == tasks.length && tasks.isNotEmpty
                        ? "🎉 All Tasks Completed!"
                        : "${(progress * 100).toInt()}% Completed",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },

              decoration: InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: const Icon(Icons.search),

                filled: true,

                fillColor: isDarkMode
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder:
                    (context, index) {


                  final task = filteredTasks[index];

                  return Dismissible(
                    key: Key(task["_id"]),

                    direction: DismissDirection.endToStart,

                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    onDismissed: (direction) async {

                      final taskId = task["_id"];

                      await TaskService.deleteTask(
                        taskId,
                      );

                      await fetchTasks();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${task["title"]} deleted",
                          ),
                        ),
                      );
                    },

                    child: Card(
                      color: isDarkMode
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,

                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),

                      child: ListTile(
                        onTap: () async {
                          await toggleTask(
                            task["_id"],
                          );
                        },

                        onLongPress: () async {
                          await showEditTaskDialog(
                            task,
                          );
                        },

                        leading: GestureDetector(
                          onTap: () async {
                            await toggleTask(
                              task["_id"],
                            );
                          },

                          child: Icon(
                            task["completed"]
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,

                            color: task["completed"]
                                ? Colors.green
                                : (isDarkMode
                                ? Colors.white
                                : Colors.black),
                          ),
                        ),

                        title: Text(
                          task["title"],

                          style: TextStyle(
                            decoration:
                            task["completed"]
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,

                            color: task["completed"]
                                ? Colors.grey
                                : (isDarkMode
                                ? Colors.white
                                : Colors.black),
                          ),
                        ),

                        subtitle: Text(
                          "${task["category"] ?? "Personal"} • 📅 ${task["dueDate"] ?? "No Date"}",

                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: showAddTaskDialog,
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          "Add Task",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}