import 'package:flutter/material.dart';
enum Day {
  sunday,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
}

class UserTraining extends StatelessWidget {
  const UserTraining({super.key});
  
  @override
  Widget build(BuildContext context) {
    List<Day> daysOfWeek = Day.values;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Customize your routine by day')),
      body: ListView.builder(
          itemCount: daysOfWeek.length,
          itemBuilder: (BuildContext context, int index) {
            Day dayForHere = daysOfWeek[index];
            String dayName = dayForHere.toString().split('.').last;
            return ListTile(
              
              title: Text(dayName),
            );
          },
        )
    );
  }
}