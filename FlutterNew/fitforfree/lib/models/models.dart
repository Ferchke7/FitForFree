// models.dart

class User {
  final String id; // Using email as the ID
  final String name;
  final int age;

  User({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }
}

class WeekdayRoutine {
  final int id;
  final String userId;
  final String weekday;

  WeekdayRoutine({required this.id, required this.userId, required this.weekday});

  Map<String, dynamic> toMap() {
    return {'id': id, 'user_id': userId, 'weekday': weekday};
  }
}

class GymRecord {
  final int id;
  final int routineId;
  final String exerciseName;
  final int weight;
  final int reps;
  final String recordDate;

  GymRecord({
    required this.id,
    required this.routineId,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.recordDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routine_id': routineId,
      'exercise_name': exerciseName,
      'weight': weight,
      'reps': reps,
      'record_date': recordDate,
    };
  }
}
