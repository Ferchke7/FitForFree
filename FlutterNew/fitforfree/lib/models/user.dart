class User {
  int? id;
  String? username;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  String? creationDate;

  User({
     this.id,
     this.username,
     this.monday,
     this.tuesday,
     this.wednesday,
     this.thursday,
     this.friday,
     this.saturday,
     this.sunday,
     this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'creation_date': creationDate,
    };
  }
}
