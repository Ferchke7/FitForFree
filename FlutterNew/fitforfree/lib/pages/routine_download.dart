import 'package:fitforfree/models/routine_dto.dart';
import 'package:flutter/material.dart';

class RoutineDonwload extends StatelessWidget {
  const RoutineDonwload({super.key, required this.routineDTO});
  final RoutineDTO routineDTO;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routine : ${routineDTO.routineName}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: 
       Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Text(routineDTO.routineName),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          child: Text(routineDTO.routineDescription),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ));
       
  }
}