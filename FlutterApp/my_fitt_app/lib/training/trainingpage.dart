import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';



class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final InfiniteScrollController _infiniteController = InfiniteScrollController(
    initialScrollOffset: 0.0,
  );

  // Map to store training information for each day
  Map<String, List<String>> trainingData = {
    'Monday': ['Monday Training 1', 'Monday Training 2', 'Monday Training 3'],
    'Tuesday': ['Tuesday Training 1', 'Tuesday Training 2', 'Tuesday Training 3'],
    'Wednesday': ['Wednesday Training 1', 'Wednesday Training 2', 'Wednesday Training 3'],
    'Thursday': ['Thursday Training 1', 'Thursday Training 2', 'Thursday Training 3'],
    'Friday': ['Friday Training 1', 'Friday Training 2', 'Friday Training 3'],
    'Saturday': ['Saturday Training 1', 'Saturday Training 2', 'Saturday Training 3'],
    'Sunday': ['Sunday Training 1', 'Sunday Training 2', 'Sunday Training 3'],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('List of your training'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () {
                _infiniteController.animateTo(_infiniteController.offset + 2000.0,
                    duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () {
                _infiniteController.animateTo(_infiniteController.offset - 2000.0,
                    duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
              },
            ),
          ],
          bottom: const TabBar(
              tabs: <Widget>[
              Tab(text: 'Monday'),
              Tab(text: 'Tuesday'),
              Tab(text: 'Wednesday'),
              Tab(text: 'Thursday'),
              Tab(text: 'Friday'),
              Tab(text: 'Saturday'),
              Tab(text: 'Sunday'),
          ],
          indicatorColor: Colors.black, // Background color of the selected tab
          labelColor: Colors.deepOrange, // Color of the selected tab text
        unselectedLabelColor: Colors.white, // Color of the unselected tab text
      ),),
        body: TabBarView(
          children: List.generate(7, (index) => _buildTab(index)),
        ),
      ),
    );
  }

  Widget _buildTab(int tab) {
    String day = _getWeekdayName(tab);
    List<String> trainingItems = trainingData[day] ?? [];

    return ListView.builder(
      itemCount: trainingItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {
              // Handle item tap
            },
            child: ListTile(
              title: Text(trainingItems[index]),
              subtitle: Text('Subtitle $index'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
    );
  }

  String _getWeekdayName(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }
}


