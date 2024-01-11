class RoutineDTO {
  int? id;
  String routineName;
  String routineDescription;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  String? user;

  RoutineDTO({
    this.id,
    required this.routineName,
    required this.routineDescription,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.user,
  });

  factory RoutineDTO.fromJson(Map<String, dynamic> json) {
    return RoutineDTO(
      id: json['id'],
      routineName: json['routineName'],
      routineDescription: json['routineDescription'],
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
      sunday: json['sunday'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routineName': routineName,
      'routineDescription': routineDescription,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'user': user,
    };
  }
}
