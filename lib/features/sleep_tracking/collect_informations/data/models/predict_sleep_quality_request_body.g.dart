// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predict_sleep_quality_request_body.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PredictSleepQualityRequestBodyAdapter
    extends TypeAdapter<PredictSleepQualityRequestBody> {
  @override
  final int typeId = 0;

  @override
  PredictSleepQualityRequestBody read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PredictSleepQualityRequestBody(
      age: fields[0] as int,
      gender: fields[1] as int,
      sleepDuration: fields[2] as double,
      physicalActivityLevel: fields[3] as double,
      stressLevel: fields[4] as int,
      bmiCategory: fields[5] as int,
      heartRate: fields[6] as int,
      dailySteps: fields[7] as int,
      sleepDisorder: fields[8] as int,
      systolicBP: fields[9] as int,
      diastolicBP: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PredictSleepQualityRequestBody obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.age)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.sleepDuration)
      ..writeByte(3)
      ..write(obj.physicalActivityLevel)
      ..writeByte(4)
      ..write(obj.stressLevel)
      ..writeByte(5)
      ..write(obj.bmiCategory)
      ..writeByte(6)
      ..write(obj.heartRate)
      ..writeByte(7)
      ..write(obj.dailySteps)
      ..writeByte(8)
      ..write(obj.sleepDisorder)
      ..writeByte(9)
      ..write(obj.systolicBP)
      ..writeByte(10)
      ..write(obj.diastolicBP);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictSleepQualityRequestBodyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictSleepQualityRequestBody _$PredictSleepQualityRequestBodyFromJson(
        Map<String, dynamic> json) =>
    PredictSleepQualityRequestBody(
      age: (json['Age'] as num).toInt(),
      gender: (json['Gender'] as num).toInt(),
      sleepDuration: (json['Sleep_Duration'] as num).toDouble(),
      physicalActivityLevel:
          (json['Physical_Activity_Level'] as num).toDouble(),
      stressLevel: (json['Stress_Level'] as num).toInt(),
      bmiCategory: (json['BMI_Category'] as num).toInt(),
      heartRate: (json['Heart_Rate'] as num).toInt(),
      dailySteps: (json['Daily_Steps'] as num).toInt(),
      sleepDisorder: (json['Sleep_Disorder'] as num).toInt(),
      systolicBP: (json['Systolic_BP'] as num).toInt(),
      diastolicBP: (json['Diastolic_BP'] as num).toInt(),
    );

Map<String, dynamic> _$PredictSleepQualityRequestBodyToJson(
        PredictSleepQualityRequestBody instance) =>
    <String, dynamic>{
      'Age': instance.age,
      'Gender': instance.gender,
      'Sleep_Duration': instance.sleepDuration,
      'Physical_Activity_Level': instance.physicalActivityLevel,
      'Stress_Level': instance.stressLevel,
      'BMI_Category': instance.bmiCategory,
      'Heart_Rate': instance.heartRate,
      'Daily_Steps': instance.dailySteps,
      'Sleep_Disorder': instance.sleepDisorder,
      'Systolic_BP': instance.systolicBP,
      'Diastolic_BP': instance.diastolicBP,
    };
