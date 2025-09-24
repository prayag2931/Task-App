// lib/screens/add_edit_task_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/theme/text_style.dart';
import 'package:task_app/model/task.dart';
import 'package:task_app/presentation/widgets/buttons.dart';
import 'package:task_app/presentation/widgets/textfield.dart';
import 'package:task_app/providers/task_provider.dart';


class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final TextEditingController _dueDateController = TextEditingController();
  DateTime? _dueDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleController = TextEditingController(text: t?.title ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _dueDate = t?.dueDate;
    if (_dueDate != null) {
      _dueDateController.text = DateFormat('dd MMM yyy hh:mm a').format(_dueDate!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
 @override
  Widget build(BuildContext context) {
    final editing = widget.task != null;
    return Scaffold(

       appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(editing ? 'Edit Task' : 'Add Task', style: AppTextStyle.darkHeadingSmall),
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back, color: Colors.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AbsorbPointer(
          absorbing: _isSaving,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                AppTextfield(hintText: 'Title', controller: _titleController, maxLength: null, maxLines: 1, validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please Enter Title';
                  }
                  return null;
                }),
                Gap(12),
                AppTextfield(hintText: 'Description', controller: _descController, maxLength: null, maxLines: 3, validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please Enter Description';
                  }
                  return null;
                }),
                Gap(12),
                AppTextfield(hintText: 'Select Due Date', controller: _dueDateController, 
                onTap: _pickDueDateTime,
                maxLength: null, validator: (value){
                   if (value == null || value.trim().isEmpty) {
                    return 'Please Select Due Date';
                  }
                  return null;
                },),
                Gap(20),
                AppButton(onTap: _save, lable: editing ? 'Save Task' : 'Add Task', isLoading: _isSaving),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future _pickDueDateTime() async {
  final now = DateTime.now();

  // Pick the date
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: _dueDate ?? now,
    firstDate: DateTime(now.year - 2),
    lastDate: DateTime(now.year + 5),
  );

  if (pickedDate != null) {
   
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
    );

    if (pickedTime != null) {
      final selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        _dueDate = selectedDateTime;
        _dueDateController.text = DateFormat('dd MMM yyy hh:mm a').format(selectedDateTime);
      });
    }
  }
}


   Future _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final provider = Provider.of<TaskProvider>(context, listen: false);

    final newTask = Task(
      id: widget.task?.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      dueDate: _dueDate,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    if (widget.task == null) {
      await provider.addTask(newTask);
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Task added', style: AppTextStyle.darkBodyMediumMedium,)));
    } else {
      await provider.updateTask(newTask);
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Task updated', style: AppTextStyle.darkBodyMediumMedium,)));
    }

    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }

 
}
