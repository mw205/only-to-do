import 'package:flutter/material.dart';
import 'package:only_to_do/features/sleep_tracking/collect_informations/data/models/option_model.dart';

class QuestionModel {
  final String question;
  List<OptionModel>? options;
  final Widget photo;
  final bool isForTimePicking;
  QuestionModel({
    required this.question,
    this.options,
    required this.photo,
    this.isForTimePicking = false,
  });
}
