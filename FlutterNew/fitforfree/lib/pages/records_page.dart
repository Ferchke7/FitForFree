import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/pages/edit_routine.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

List<String> daysOfWeek = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

class AddRecords extends StatefulWidget {
  const AddRecords({super.key});

  @override
  State<AddRecords> createState() => _AddRecordsState();
}

class _AddRecordsState extends State<AddRecords> {
  UserService userService = UserService();
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _initCurrentUser();
  }

  Future<void> _initCurrentUser() async {
    User? loadedUser = await userService.getUserByUsername(my_username!);

    setState(() {
      currentUser = loadedUser!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: ListView.builder(
          itemCount: daysOfWeek.length,
          itemBuilder: (context, index) {
            String day = daysOfWeek[index];
            return Card(
              child: ListTile(
                title: Text("Day of: ${daysOfWeek[index]}\nPress for details", style: TextStyle(color: Colors.indigo),),
                trailing: const Icon(Icons.wysiwyg_sharp, color: Colors.indigo,),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditRoutine(
                                day: day,
                              )));
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton.small(
          backgroundColor: Colors.indigo,
          onPressed: () {},
          child: const Icon(
            Icons.sync,
            color: Colors.white,
          )),
    );
  }
}
