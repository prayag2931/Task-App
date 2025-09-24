import 'package:flutter/widgets.dart';
import 'package:task_app/database/db_helper.dart';
import 'package:task_app/model/task.dart';

enum TaskFilter { all, completed, pending, sort }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool isLoading = true;
  TaskFilter filter = TaskFilter.all;
  bool sortByDueAsc = true;

  List<Task> get tasks {
    var list = [..._tasks];
    if (filter == TaskFilter.completed) {
      list = list.where((t) => t.isCompleted).toList();
    } else if (filter == TaskFilter.pending) {
      list = list.where((t) => !t.isCompleted).toList();
    }
    list.sort((a, b) {
      final da = a.dueDate?.millisecondsSinceEpoch ?? 0;
      final db = b.dueDate?.millisecondsSinceEpoch ?? 0;
      return sortByDueAsc ? da.compareTo(db) : db.compareTo(da);
    });
    return list;
  }

  Future loadTasks() async {
    isLoading = true;
    notifyListeners();
    _tasks = await DatabaseHelper.instance.getTasks();
    isLoading = false;
    notifyListeners();
  }

  Future addTask(Task task) async {
    final id = await DatabaseHelper.instance.insertTask(task);
    final newTask = task.copyWith(id: id);
    _tasks.add(newTask);
    notifyListeners();
  }

  Future updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    final idx = _tasks.indexWhere((t) => t.id == task.id);
    if (idx != -1) {
      _tasks[idx] = task;
      notifyListeners();
    } else {
      await loadTasks();
    }
  }

  Future deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future markComplete(Task task) async {
    final updated = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updated);
  }

  void setFilter(TaskFilter newFilter) {
    filter = newFilter;
    notifyListeners();
  }

  void sortBydate() {
    sortByDueAsc = !sortByDueAsc;
    notifyListeners();
  }
}
