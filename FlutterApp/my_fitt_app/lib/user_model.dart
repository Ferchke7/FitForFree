class UserModel {
  final String id;
  final String name;
  final String lastname;
  final int age;
  UserModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.age,
  });
  factory UserModel.fromJson(Map<String, dynamic> data) => UserModel(
    id: data['id'],
    name: data['title'],
    lastname: data['language'],
    age: data['year'],
  );
  Map<String, dynamic> toMap() => {
  'id': id,
  'name': name,
  'lastname': lastname,
  'age': age
};
}