import 'package:fitness_fatality_flutter/data/entities/logs/logging_parameters/reps_logging.dart';
import 'package:fitness_fatality_flutter/data/entities/workout/workout_exercise.dart';

class WorkoutExerciseRepository {
  Future<int> assignExerciseWithDefaultValues(int exerciseId, int workoutId) {
    return WorkoutExercise(
      exerciseId: exerciseId, 
      workoutId: workoutId,
      loggingTarget: RepsLogging({"sets": 3, "reps": 8}),
    ).save();
  }

  void fetchAllWorkoutExercises() {
    WorkoutExercise.fetchAllWorkoutExercises();
  }

  Future<List<WorkoutExercise>> fetchByWorkoutId(int workoutId) async {

//    var a = await WorkoutExercise.fetchAllWorkoutExercises();

    return  await WorkoutExercise.fetchByWorkoutId(workoutId);
  }
}