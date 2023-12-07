class Training {
  String userId;
  String activityName;
  int repNumber;
  int weight;
  DateTime createdAt;

  Training({required this.userId,required this.activityName ,required this.repNumber, required this.weight, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'activityName': activityName,
      'repNumber': repNumber,
      'weight': weight,
      'date': createdAt.toIso8601String(),
    };
  }

  factory Training.fromMap(Map<String, dynamic> map) {
    return Training(
      userId: map['userId'],
      activityName: map['activityName'],
      repNumber: map['repNumber'],
      weight: map['weight'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
