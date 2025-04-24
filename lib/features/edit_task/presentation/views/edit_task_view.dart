import 'package:flutter/material.dart';
import 'package:only_to_do/features/edit_task/presentation/views/widget/edit_task_view_body.dart';

class EditTaskView extends StatelessWidget {
  const EditTaskView({super.key});
  static String id = "/EditTask";

  @override
  Widget build(BuildContext context) {
    return const EditTaskViewBody();
  }
}
