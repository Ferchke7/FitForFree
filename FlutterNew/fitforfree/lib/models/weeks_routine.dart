class WeekRoutines {
  int? id;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  int? foreignKey;

  WeekRoutines({
    this.id,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.foreignKey,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monday': monday,
      'tueday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'foreignKey': foreignKey,
    };
  }

  factory WeekRoutines.fromMap(Map<String, dynamic> map) {
    return WeekRoutines(
      id: map['id'],
      monday: map['monday'],
      tuesday: map['tuesday'],
      wednesday: map['wednesday'],
      thursday: map['thursday'],
      friday: map['friday'],
      saturday: map['saturday'],
      sunday: map['sunday'],
      foreignKey: map['foreignKey'],
    );
  }
}