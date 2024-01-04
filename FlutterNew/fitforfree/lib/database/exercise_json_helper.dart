import 'dart:convert';

import 'package:fitforfree/models/exercise.dart';

class ExerciseService {
  String encodeExercises(List<Exercise> exercises) {
    List<Map<String, dynamic>> exerciseJsonList = exercises.map((exercise) => exercise.toJson()).toList();
    Map<String, dynamic> data = {'exercises': exerciseJsonList};
    return jsonEncode(data);
  }

  List<Exercise> decodeExercises(String jsonString) {
    Map<String, dynamic> decodedData = jsonDecode(jsonString);
    List<dynamic> exerciseJsonList = decodedData['exercises'];
    return exerciseJsonList.map((json) => Exercise.fromJson(json)).toList();
  }

  void updateExercise(List<Exercise> exercises, String targetExerciseName, int newRepsValue, int newWeightValue) {
    for (var exercise in exercises) {
      if (exercise.name == targetExerciseName) {
        exercise.reps = newRepsValue;
        exercise.weight = newWeightValue;
        break;
      }
    }
  }

  void addExercise(List<Exercise> exercises, String name, int reps, int weight) {
    exercises.add(Exercise(name: name, reps: reps, weight: weight));
  }

  void deleteExercise(List<Exercise> exercises, String targetExerciseName) {
    exercises.removeWhere((exercise) => exercise.name == targetExerciseName);
  }
}