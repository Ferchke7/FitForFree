import 'package:accordion/accordion.dart';
import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/routine_dto.dart';
import 'package:fitforfree/pages/downloaded_listtable.dart';
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
  List<List<Exercise>> listOfExercises = [];
  @override
  void initState(){
    super.initState();
    populateExer();
  }

  void populateExer() {
    if(widget.routineDTO.monday != null) {
      listOfExercises.add(exerciseService.decodeExercises(widget.routineDTO.monday!));
    }
    if(widget.routineDTO.tuesday != null) {
      
      listOfExercises.add(exerciseService.decodeExercises(widget.routineDTO.tuesday!));
    }
    
    if(widget.routineDTO.wednesday != null) {
      listOfExercises.add(exerciseService.decodeExercises(widget.routineDTO.wednesday!));
    }
    if(widget.routineDTO.thursday != null) {
      listOfExercises.add(exerciseService.decodeExercises(widget.routineDTO.thursday!));
    }
    if(widget.routineDTO.friday != null) {
      listOfExercises.add(exerciseService.decodeExercises(widget.routineDTO.friday!));
    }
    if(widget.routineDTO.saturday != null) {
      listOfExercises.add(exerciseService.decodeExercises(widget.routineDTO.saturday!));
    }
    if(widget.routineDTO.sunday != null) {
      listOfExercises.add(exerciseService.decodeExercises(widget.routineDTO.sunday!));
    }    
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
                margin: const EdgeInsets.all(20),
                child: Column(
                  
                  children: <Widget>[
                    SizedBox(
                      width: 390,
                      
                      child: Accordion(headerBorderWidth: 10, children: [
                      AccordionSection(
                          contentVerticalPadding: 20,
                          
                          header: Text(
                            "Routine creator: ${widget.routineDTO.user}\ndescription:\n${widget.routineDTO.routineDescription}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          content: SingleChildScrollView(
                              child: Column(
                            children: <Widget>[
                              DowloadedListTable(listOfExercises: listOfExercises,)
                                   
                            ],
                          )))
                    ]),
                    ),

                    
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
