import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class AddRecords extends StatefulWidget {
  const AddRecords({super.key});

  @override
  State<AddRecords> createState() => _AddRecordsState();
}

class _AddRecordsState extends State<AddRecords> {
  UserService userService = UserService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The routine"),
        centerTitle: true,
        actions: <Widget>[

        ],
      ),
      floatingActionButton: 
      FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 24, 6, 97),
        onPressed: () {
          print("USER ID AND NAME IS $userId ");
      },
        child: const Icon(Icons.add_box,color: Colors.white,) ),
    );
  }
}