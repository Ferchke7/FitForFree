import 'package:fitforfree/database/database_helper.dart';
import 'package:fitforfree/models/Routine.dart';
import 'package:fitforfree/services/dropmenu_routines.dart';
import 'package:flutter/material.dart';

class AddRoutines extends StatefulWidget {
  const AddRoutines({super.key});

  @override
  _AddRoutinesState createState() => _AddRoutinesState();
}

class _AddRoutinesState extends State<AddRoutines> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController nameOfRoutine = new TextEditingController();

  Future showDialogAdding() {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Input data"),
          content: TextField(
            controller: nameOfRoutine,
            decoration: const InputDecoration(
              hintText: "Name of Routine"
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("Add"),
              onPressed: () async {
                String tempText = nameOfRoutine.text;
                Routine routine = Routine(name: tempText);
                await _databaseHelper.insertRoutine(routine);
                Navigator.pop(context);
                refreshPage();
                
              }
              ),
            MaterialButton(
              color: Colors.black,
              textColor: Colors.white,
              child: Text("Cancel"),
              onPressed:(){
                setState(() {
                  Navigator.pop(context);
                });
              }),
            
          ],
        );
      });
  }
  String? valueText; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Routines'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Routine>>(
        future: _databaseHelper.getRoutines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Routine>? routines = snapshot.data;
            return ListView.builder(
              itemCount: routines!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(routines[index].name),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuClick(value),
                      itemBuilder: (BuildContext context) {
                        return ['edit','delete'].map((String option) {
                          return PopupMenuItem(
                            value: option,
                            child: Text(option));
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        
        children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              showDialogAdding();
              setState(() {
                
              });
              
            }),
          FloatingActionButton(
            
            child: const Icon(Icons.delete),
            
            onPressed: ()
          {
            _databaseHelper.deleteAllRoutines();
            Navigator.pop(context);
          }),
          
        ],
      )
    );
  }

  void _handleMenuClick(String value) {
    if (value == 'edit') {
      
    }
    else if (value == 'delete') {

    }
  }
  void refreshPage() {
  setState(() {});
}
}
