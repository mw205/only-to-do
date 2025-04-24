import 'package:flutter/material.dart';
import 'package:only_to_do/gen/colors.gen.dart';

class Task {
  final String title;
  final String time;
  final Color color;
  final bool completed;

  Task(this.title, this.time, this.color, this.completed);
}

final List<Task> todayTasks = [
  Task("Watch 1 design masterclass", "18h30", ColorName.red, false),
  Task("Feed the cat", "20h30", ColorName.yellow, false),
];

final List<Task> inboxTasks = [
  Task("E-mail Fred about job proposal", "", ColorName.yellow, false),
  Task("Update portfolio", "", ColorName.green, true),
  Task(
    "Buy christmas presents for family, visit website for ideas",
    "",
    ColorName.green,
    false,
  ),
];
