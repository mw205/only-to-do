import 'dart:convert';

class PredictSleepQualityRequestBody {
  final int age;
  final int gender;
  final double sleepDuration;
  final double physicalActivityLevel;
  final int stressLevel;
  final int bmiCategory;
  final int heartRate;
  final int minDailySteps;
  final int hasSleepDisorder;
  final int systolicBP;
  final int diastolicBP;

  PredictSleepQualityRequestBody({
    required this.age,
    required this.gender,
    required this.sleepDuration,
    required this.physicalActivityLevel,
    required this.stressLevel,
    required this.bmiCategory,
    required this.heartRate,
    required this.minDailySteps,
    required this.hasSleepDisorder,
    required this.systolicBP,
    required this.diastolicBP,
  });

  PredictSleepQualityRequestBody copyWith({
    int? age,
    int? gender,
    double? sleepDuration,
    double? physicalActivityLevel,
    int? stressLevel,
    int? bmiCategory,
    int? heartRate,
    int? minDailySteps,
    int? hasSleepDisorder,
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
      minDailySteps: minDailySteps ?? this.minDailySteps,
      hasSleepDisorder: hasSleepDisorder ?? this.hasSleepDisorder,
      systolicBP: systolicBP ?? this.systolicBP,
      diastolicBP: diastolicBP ?? this.diastolicBP,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'age': age,
      'gender': gender,
      'sleepDuration': sleepDuration,
      'physicalActivityLevel': physicalActivityLevel,
      'stressLevel': stressLevel,
      'bmiCategory': bmiCategory,
      'heartRate': heartRate,
      'minDailySteps': minDailySteps,
      'hasSleepDisorder': hasSleepDisorder,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
    };
  }

  factory PredictSleepQualityRequestBody.fromMap(Map<String, dynamic> map) {
    return PredictSleepQualityRequestBody(
      age: map['age'] as int,
      gender: map['gender'] as int,
      sleepDuration: map['sleepDuration'] as double,
      physicalActivityLevel: map['physicalActivityLevel'] as double,
      stressLevel: map['stressLevel'] as int,
      bmiCategory: map['bmiCategory'] as int,
      heartRate: map['heartRate'] as int,
      minDailySteps: map['minDailySteps'] as int,
      hasSleepDisorder: map['hasSleepDisorder'] as int,
      systolicBP: map['systolicBP'] as int,
      diastolicBP: map['diastolicBP'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PredictSleepQualityRequestBody.fromJson(String source) =>
      PredictSleepQualityRequestBody.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PredictSleepQualityRequestBody(age: $age, gender: $gender, sleepDuration: $sleepDuration, physicalActivityLevel: $physicalActivityLevel, stressLevel: $stressLevel, bmiCategory: $bmiCategory, heartRate: $heartRate, minDailySteps: $minDailySteps, hasSleepDisorder: $hasSleepDisorder, systolicBP: $systolicBP, diastolicBP: $diastolicBP)';
  }

  @override
  bool operator ==(covariant PredictSleepQualityRequestBody other) {
    if (identical(this, other)) return true;
    return other.age == age &&
        other.gender == gender &&
        other.sleepDuration == sleepDuration &&
        other.physicalActivityLevel == physicalActivityLevel &&
        other.stressLevel == stressLevel &&
        other.bmiCategory == bmiCategory &&
        other.heartRate == heartRate &&
        other.minDailySteps == minDailySteps &&
        other.hasSleepDisorder == hasSleepDisorder &&
        other.systolicBP == systolicBP &&
        other.diastolicBP == diastolicBP;
  }

  @override
  int get hashCode {
    return age.hashCode ^
        gender.hashCode ^
        sleepDuration.hashCode ^
        physicalActivityLevel.hashCode ^
        stressLevel.hashCode ^
        bmiCategory.hashCode ^
        heartRate.hashCode ^
        minDailySteps.hashCode ^
        hasSleepDisorder.hashCode ^
        systolicBP.hashCode ^
        diastolicBP.hashCode;
  }
}
