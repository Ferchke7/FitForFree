import 'package:accordion/accordion.dart';
import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
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
  UserService userService = UserService();
  ExerciseService exerciseService = ExerciseService();
  late List<Exercise> listExercise;
  @override
  void initState(){
    super.initState();
    
  }

  


  @override
  Widget build(BuildContext context) {
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
                            style: const TextStyle(color: Colors.white),
                          ),
                          content: SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                      "Routine for monday: \n${widget.routineDTO.monday}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                      "Routine for tuesday: \n${widget.routineDTO.tuesday}"),
                              ),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Text(
                                      "Routine for wednesday: \n${widget.routineDTO.wednesday}"),
                                   ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                      "Routine for thursday: \n${widget.routineDTO.thursday}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                      "Routine for friday: \n${widget.routineDTO.friday}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                      "Routine for saturday: \n${widget.routineDTO.saturday}"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                      "Routine for sunday: \n${widget.routineDTO.sunday}"),
                                    ),
                                     
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
                            ),
                          );
                          Navigator.pop(context);
                        });
                      },
                      icon: const Icon(Icons.download),
                      label: const Text("Download and use this routine"))
                ],
              )
            ],
          ),
        ));
  }
}
