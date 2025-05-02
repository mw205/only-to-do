import 'package:flutter/material.dart';
import 'package:only_to_do/features/informations/data/option_model.dart';

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
