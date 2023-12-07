import 'dart:ffi';

class User {
  final String id;
  final String name;
  final String email;
  final DateTime? dateOfBirth;
  late final List<Training> trainings;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.dateOfBirth,
    this.trainings = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Training> trainings = [];
    if (json['trainings'] != null) {
      trainings = (json['trainings'] as List)
          .map((trainingJson) => Training.fromJson(trainingJson))
          .toList();
    }

    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      trainings: trainings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'trainings': trainings.map((training) => training.toJson()).toList(),
    };
  }
}

class Training {
  final String dayOfWeek;
  final List<Record> records;

  Training({
    required this.dayOfWeek,
    this.records = const [],
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    List<Record> records = [];
    if (json['records'] != null) {
      records = (json['records'] as List)
          .map((recordJson) => Record.fromJson(recordJson))
          .toList();
    }

    return Training(
      dayOfWeek: json['dayOfWeek'],
      records: records,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'records': records.map((record) => record.toJson()).toList(),
    };
  }
}

class Record {
  final DateTime date;
  final List<Rep> reps;

  Record({
    required this.date,
    this.reps = const [],
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    List<Rep> reps = [];
    if (json['reps'] != null) {
      reps = (json['reps'] as List)
          .map((repJson) => Rep.fromJson(repJson))
          .toList();
    }

    return Record(
      date: DateTime.parse(json['date']),
      reps: reps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'reps': reps.map((rep) => rep.toJson()).toList(),
    };
  }
}

class Rep {
  final int count;
  final Long weight;

  Rep({
    required this.count,
    required this.weight,
  });

  factory Rep.fromJson(Map<String, dynamic> json) {
    return Rep(
      count: json['count'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'weight': weight,
    };
  }
}
