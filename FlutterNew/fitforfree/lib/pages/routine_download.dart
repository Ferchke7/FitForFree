import 'package:accordion/accordion.dart';
import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/routine_dto.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class RoutineDonwload extends StatefulWidget {
  const RoutineDonwload({super.key, required this.routineDTO});
  final RoutineDTO routineDTO;

  @override
  State<RoutineDonwload> createState() => _RoutineDonwloadState();
}

class _RoutineDonwloadState extends State<RoutineDonwload> {
  @override
  Widget build(BuildContext context) {
    UserService userService = UserService();
    ExerciseService exerciseService = ExerciseService();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Routine : ${widget.routineDTO.routineName}",
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    Accordion(headerBorderWidth: 20, children: [
                      AccordionSection(
                          contentVerticalPadding: 20,
                          header: Text(
                            "Routine creator: ${widget.routineDTO.user}\ndescription:\n${widget.routineDTO.routineDescription}",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              Text("Routine for monday: ${widget.routineDTO.monday}")
                            ],
                          )))
                    ])
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  ElevatedButton.icon(
                      onPressed: () async {
                        var userTemp =
                            await userService.getUserByUsername(my_username!);
                        userTemp?.monday = widget.routineDTO.monday;
                        userTemp?.tuesday = widget.routineDTO.tuesday;
                        userTemp?.wednesday = widget.routineDTO.wednesday;
                        userTemp?.thursday = widget.routineDTO.thursday;
                        userTemp?.friday = widget.routineDTO.friday;
                        userTemp?.sunday = widget.routineDTO.sunday;
                        userTemp?.saturday = widget.routineDTO.saturday;
                        setState(() {
                          userService.updateUser(userTemp!);
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text('Updated'),
                        backgroundColor: Color.fromARGB(255, 4, 213, 77),
                      ),);
                        Navigator.pop(context);
                        });
                      },
                      icon: Icon(Icons.download),
                      label: Text("Download"))
                ],
              )
            ],
          ),
        ));
  }
}
