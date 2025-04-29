import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_to_do/gen/colors.gen.dart';

import '../../../../edit_task/presentation/views/edit_task_view.dart';
import 'tasks.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            SectionTitle(title: "Today"),
            ...todayTasks.map((task) => TaskItem(task: task)),
            const SizedBox(height: 20),
            SectionTitle(title: "Inbox"),
            ...inboxTasks.map((task) => TaskItem(task: task)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: ColorName.purple,
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push(EditTaskView.id);
      },
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        task.completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: Colors.black,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.time.isNotEmpty
          ? Text(task.time, style: TextStyle(color: Colors.grey))
          : null,
      trailing: CircleAvatar(radius: 6, backgroundColor: task.color),
    );
  }
}
