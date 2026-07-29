import 'package:hive/hive.dart';

/// Hive box name for persisted meal logs.
const mealLogBoxName = 'logged_meals';

/// Hive typeId for [LoggedMealHiveModel]. Must stay unique across the app.
const loggedMealHiveTypeId = 10;

/// Hive-persisted record of a logged meal.
class LoggedMealHiveModel {
  final String id;
  final String foodName;
  final int calories;
  final int healthScore;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final String? imagePath;
  final DateTime loggedAt;

  const LoggedMealHiveModel({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.healthScore,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.loggedAt,
    this.imagePath,
  });
}

/// Manual `TypeAdapter` (no build_runner) for [LoggedMealHiveModel].
class LoggedMealHiveModelAdapter extends TypeAdapter<LoggedMealHiveModel> {
  @override
  final int typeId = loggedMealHiveTypeId;

  @override
  LoggedMealHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoggedMealHiveModel(
      id: fields[0] as String,
      foodName: fields[1] as String,
      calories: fields[2] as int,
      healthScore: fields[3] as int,
      proteinGrams: fields[4] as int,
      carbsGrams: fields[5] as int,
      fatGrams: fields[6] as int,
      imagePath: fields[7] as String?,
      loggedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LoggedMealHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.foodName)
      ..writeByte(2)
      ..write(obj.calories)
      ..writeByte(3)
      ..write(obj.healthScore)
      ..writeByte(4)
      ..write(obj.proteinGrams)
      ..writeByte(5)
      ..write(obj.carbsGrams)
      ..writeByte(6)
      ..write(obj.fatGrams)
      ..writeByte(7)
      ..write(obj.imagePath)
      ..writeByte(8)
      ..write(obj.loggedAt);
  }
}
