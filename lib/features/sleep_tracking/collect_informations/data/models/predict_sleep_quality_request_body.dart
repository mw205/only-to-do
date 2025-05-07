import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'predict_sleep_quality_request_body.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(fieldRename: FieldRename.pascal)
class PredictSleepQualityRequestBody extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'Age')
  final int age;

  @HiveField(1)
  @JsonKey(name: 'Gender')
  final int gender; // 0 for Male, 1 for Female

  @HiveField(2)
  @JsonKey(name: 'Sleep_Duration')
  final double sleepDuration;

  @HiveField(3)
  @JsonKey(name: 'Physical_Activity_Level')
  final double physicalActivityLevel; // in minutes/day

  @HiveField(4)
  @JsonKey(name: 'Stress_Level')
  final int stressLevel; // scale 1-10

  @HiveField(5)
  @JsonKey(name: 'BMI_Category')
  final int bmiCategory; // e.g., 0:Underweight, 1:Normal, 2:Overweight, 3:Obese

  @HiveField(6)
  @JsonKey(name: 'Heart_Rate')
  final int heartRate; // bpm

  @HiveField(7)
  @JsonKey(name: 'Daily_Steps')
  final int dailySteps;

  @HiveField(8)
  @JsonKey(name: 'Sleep_Disorder')
  final int sleepDisorder; // 0:None, 1:Insomnia, 2:Sleep Apnea

  @HiveField(9)
  @JsonKey(name: 'Systolic_BP')
  final int systolicBP;

  @HiveField(10)
  @JsonKey(name: 'Diastolic_BP')
  final int diastolicBP;

  PredictSleepQualityRequestBody({
    required this.age,
    required this.gender,
    required this.sleepDuration,
    required this.physicalActivityLevel,
    required this.stressLevel,
    required this.bmiCategory,
    required this.heartRate,
    required this.dailySteps,
    required this.sleepDisorder,
    required this.systolicBP,
    required this.diastolicBP,
  });

  // --- copyWith, fromJson, toJson, and toString methods remain the same ---

  PredictSleepQualityRequestBody copyWith({
    int? age,
    int? gender,
    double? sleepDuration,
    double? physicalActivityLevel,
    int? stressLevel,
    int? bmiCategory,
    int? heartRate,
    int? dailySteps,
    int? sleepDisorder,
    int? systolicBP,
    int? diastolicBP,
  }) {
    return PredictSleepQualityRequestBody(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      physicalActivityLevel:
          physicalActivityLevel ?? this.physicalActivityLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      bmiCategory: bmiCategory ?? this.bmiCategory,
      heartRate: heartRate ?? this.heartRate,
      dailySteps: dailySteps ?? this.dailySteps,
      sleepDisorder: sleepDisorder ?? this.sleepDisorder,
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
    );
  }

  factory PredictSleepQualityRequestBody.fromJson(Map<String, dynamic> json) =>
      _$PredictSleepQualityRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PredictSleepQualityRequestBodyToJson(this);

  @override
  String toString() {
    return 'PredictSleepQualityRequestBody(Age: $age, Gender: $gender, Sleep_Duration: $sleepDuration, Physical_Activity_Level: $physicalActivityLevel, Stress_Level: $stressLevel, BMI_Category: $bmiCategory, Heart_Rate: $heartRate, Daily_Steps: $dailySteps, Sleep_Disorder: $sleepDisorder, Systolic_BP: $systolicBP, Diastolic_BP: $diastolicBP)';
  }
}
