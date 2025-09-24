import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/theme/text_style.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/presentation/widgets/buttons.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onComplete,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeText = task.dueDate != null
        ? DateFormat('hh:mm a').format(task.dueDate!)
        : "--:--";
    final dueText = task.dueDate != null
        ? DateFormat('dd MMM yyyy').format(task.dueDate!)
        : 'No due date';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: task.isCompleted
                    ? Colors.green.withOpacity(0.25)
                    : const Color(0xFFE8F2F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title & Menu ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: AppTextStyle.lightBodyLargeBold.copyWith(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        elevation: 4,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          if (value == "edit") onEdit();
                          if (value == "delete") {
                            showDeleteConfirmationDialog(context)
                                .then((confirmed) {
                              if (confirmed == true) {
                                onDelete();
                              }
                            });
                          }
                          if (value == "toggle") onComplete();
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "toggle",
                            child: Row(
                              children: [
                                Icon(
                                  task.isCompleted
                                      ? Icons.undo
                                      : Icons.check_circle,
                                  size: 18,
                                  color: task.isCompleted
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                                 Gap(10),
                                Text(
                                  task.isCompleted
                                      ? "Mark As Incomplete"
                                      : "Mark As Complete",
                                  style: AppTextStyle.lightBodyMediumMedium,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: "edit",
                            child: Row(
                              children: [
                                const Icon(Icons.edit,
                                    size: 18, color: Colors.blue),
                                Gap(10),
                                Text(
                                  "Edit Task",
                                  style: AppTextStyle.lightBodyMediumMedium,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: "delete",
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outline,
                                    size: 18, color: Colors.red),
                                Gap(10),
                                Text(
                                  "Delete Task",
                                  style: AppTextStyle.lightBodyMediumMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                        icon: const Icon(
                          Icons.more_vert,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // --- Description ---
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      style: AppTextStyle.lightBodyMediumRegular.copyWith(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),

                  const Gap(20),

                  // --- Due Date & Time ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTimeRow(text: dueText, icon: Icons.calendar_today),
                      buildTimeRow(
                        text: timeText,
                        icon: Icons.watch_later_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeRow({required String text, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black54),
         Gap(6),
        Text(
          text,
          style: AppTextStyle.lightBodySmallMedium.copyWith(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Future<bool?> showDeleteConfirmationDialog(BuildContext context) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Delete Confirmation',
    barrierColor: Colors.black54, // background dim
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      // The actual dialog content
      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 48, color: Colors.red),
              Gap(12),
                 Text(
                  "Delete Task?",
                  style: AppTextStyle.lightBodyLargeBold,
                ),
               Gap(8),
                const Text(
                  "Are you sure you want to delete this task?",
                  textAlign: TextAlign.center,
                ),
                 Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 10,
                  children: [
                     Expanded(child: AppButton(onTap: () => Navigator.of(context).pop(false), lable: "Cancel")),
                
                   
                    Expanded(child: AppButton(onTap: () => Navigator.of(context).pop(true), lable: "Delete", color: Colors.red,)),
                  
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1), // from bottom
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}
}
