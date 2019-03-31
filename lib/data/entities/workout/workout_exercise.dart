import 'package:fitness_fatality_flutter/data/database/database_provider.dart';
import 'package:fitness_fatality_flutter/data/entities/exercise/exercise.dart';
import 'package:fitness_fatality_flutter/data/entities/logs/logging_parameters/logging_target_abstract.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutExercise {
  int id;
  int workoutId;
  int exerciseId;
  int sequenceId;
  Exercise exercise;
  LoggingMethod loggingMethod;
  LoggingTargetAbstract loggingTarget;

  WorkoutExercise({
    this.id,
    this.workoutId,
    this.exerciseId,
    this.sequenceId = 100,
    this.exercise,
    this.loggingMethod = LoggingMethod.REPS,
    this.loggingTarget,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "workoutId": workoutId,
      "exerciseId": exerciseId,
      "sequenceId": sequenceId,
      "loggingMethod": loggingMethod.index,
      "loggingTarget": loggingTarget.toJson(),
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
        id: json['id'],
        workoutId: json['workoutId'],
        exerciseId: json['exerciseId'],
        sequenceId: json['sqeuenceId'],
        loggingMethod: LoggingMethod.values[json['loggingMethod']],
        loggingTarget: LoggingTargetAbstract.fromJson(json['loggingTarget']));
  }

  Future<int> save() async {
    final db = await DatabaseProvider.database;
    return db.insert("workout_exercise", this.toJson());
  }

  static Future<List<WorkoutExercise>> fetchAllWorkoutExercises() async {
    final Database db = await DatabaseProvider.database;
    List<Map<String, dynamic>> data = await db.query("workout_exercise");

    if(data.length > 0) {
      return data.map((dynamic row) => WorkoutExercise.fromJson(row)).toList();
    }

    return null;
  }

  static Future<List<WorkoutExercise>> fetchByWorkoutId(int workoutId) async {
    final Database db = await DatabaseProvider.database;
    List<Map> data = await db.query(
      "workout_exercise",
      where: "workoutId = ?",
      whereArgs: [workoutId],
    );

    if (data.length > 0) {
      List<WorkoutExercise> result = 
        data.map((dynamic row) => WorkoutExercise.fromJson(row)).toList();

      for(WorkoutExercise we in result) {
        we.exercise = await Exercise.fetchExerciseById(we.exerciseId);
      }

      return result; 
    }

    return null;
  }
}
