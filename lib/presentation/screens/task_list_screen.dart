import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:task_app/core/theme/text_style.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/presentation/widgets/task_item.dart';
import 'package:task_app/providers/task_provider.dart';
import 'package:task_app/presentation/screens/add_edit_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<String> tabs = ['All', 'Completed', 'Pending'];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditTaskScreen()),
        ),
        label: Text('Add Task', style: AppTextStyle.darkBodyMediumMedium),
        icon: const Icon(Icons.add, color: Colors.white),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('All Tasks', style: AppTextStyle.darkHeadingSmall),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => taskProvider.sortBydate(),
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => taskProvider.loadTasks(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: 35,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    separatorBuilder: (_, __) => const Gap(12),
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });

                          if (tabs[index] == 'All') {
                            taskProvider.setFilter(TaskFilter.all);
                          } else if (tabs[index] == 'Completed') {
                            taskProvider.setFilter(TaskFilter.completed);
                          } else if (tabs[index] == 'Pending') {
                            taskProvider.setFilter(TaskFilter.pending);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black87
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Center(
                            child: Text(
                              tabs[index],
                              style: AppTextStyle.lightBodyLargeSemiBold
                                  .copyWith(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF868D95),
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              taskProvider.isLoading
                  ? Expanded(
                      child: Center(
                        child: LoadingAnimationWidget.discreteCircle(
                          secondRingColor: Colors.blue.shade100,
                          color: Colors.black87,
                          size: 28,
                        ),
                      ),
                    )
                  : taskProvider.tasks.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'No tasks available.',
                          style: AppTextStyle.lightBodyLargeMedium,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: taskProvider.tasks.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return TaskItem(
                            task: task,
                            onComplete: () async {
                              await taskProvider.markComplete(task);
                            },
                            onEdit: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditTaskScreen(task: task),
                              ),
                            ),
                            onDelete: () async {
                              await taskProvider.deleteTask(task.id!);
                            },
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
