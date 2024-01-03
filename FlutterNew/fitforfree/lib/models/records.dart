class Records {
  final int id;
  final int userId; // Foreign key reference to the User table
  final String record;
  final String weekName; // Add week name field
  final String date; // Add date field

  Records({
    required this.id,
    required this.userId,
    required this.record,
    required this.weekName,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'record': record,
      'week_name': weekName, // Map week name
      'date': date, // Map date
    };
  }
}
