import 'package:fitforfree/models/exercise.dart';
import 'package:flutter/material.dart';

class MyInputForm extends StatefulWidget //__
{
  final Exercise exercise;

  const MyInputForm({Key? key, required this.exercise}) : super(key: key);

  @override
  State<MyInputForm> createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {

  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    createControllers(widget.exercise.reps);
  }
  


  void disposeControllers() {
    for (TextEditingController controller in controllers) {
      controller.dispose();
    }
  }

  @override
  dispose() {
    disposeControllers();
    super.dispose();
  }

  void createControllers(int numberOfControllers) {
    for (int i = 0; i < numberOfControllers; i++) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
    }
  }

  @override
  Widget build(context) //__
  {
    return Column(
      children: 
      <Widget>[
        Column(
          children: List.generate(controllers.length, (index) {
           return Column(
            children: <Widget>[
              TextField(
              controller: controllers[index],
              decoration: InputDecoration(
                hintText: 'Text Field ${index +1}'
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text("ADD"))
            ],
           );
          }),
        )
      ]
    );
  }
}
