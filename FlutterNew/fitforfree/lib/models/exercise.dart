class Exercise {
  String name;
  int reps;
  int weight;

  Exercise({
    required this.name,
    required this.reps,
    required this.weight,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      reps: json['reps'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reps': reps,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'Exercise{name: $name, reps: $reps, weight: $weight}';
  }
}