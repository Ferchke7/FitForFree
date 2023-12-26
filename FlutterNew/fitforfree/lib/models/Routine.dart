class Routine {
  final int? id;
  final String name;

  Routine({this.id, required this.name});

  Routine.fromMap(Map<String, dynamic>? routines)
      : id = routines?["id"],
        name = routines?["name"] ?? '';

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }

  Map<String, Object> toMapWithoutId() {
    return {'name': name};
  }
}