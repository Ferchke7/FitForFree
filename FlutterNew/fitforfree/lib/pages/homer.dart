import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitforfree/models/news.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/pages/show_all_data.dart';
import 'package:fitforfree/pages/start_tday_routine.dart';
import 'package:fitforfree/pages/weekday_graph.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomerPage extends StatefulWidget {
  const HomerPage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomerPage> {
  late NewsResponse newsResponse = NewsResponse(articles: []);

  @override
  void initState() {
    super.initState();
    getNewsResponsesTemp().then((value) {
      setState(() {
        newsResponse = value;
      });
    });
  }

  Future<void> getNewsResponses() async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=6b470d0680cd413e9c119bf0d4960478"));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      setState(() {
        newsResponse = NewsResponse.fromJson(jsonMap);
      });
    } else {
      throw Exception('Failed to load news data');
    }
  }

  Future<NewsResponse> getNewsResponsesTemp() async {
    final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=6b470d0680cd413e9c119bf0d4960478"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);

      // Handle null values in the JSON map during initialization
      final sanitizedJsonMap = Map<String, dynamic>.from(jsonMap)
        ..removeWhere((key, value) => value == null);

      return NewsResponse.fromJson(sanitizedJsonMap);
    } else {
      throw Exception('Failed to load news data');
    }
  }

  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  Future<bool> ifExerciseIsEmpty(String dayOfWeek) async {
    User? currentUser = await userService.getUserByUsername(my_username!);
    bool result = false;
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        result = currentUser?.monday == null;

        break;
      case 'tuesday':
        result = currentUser?.tuesday == null;

        break;
      case 'wednesday':
        result = currentUser?.wednesday == null;
        break;
      case 'thursday':
        result = currentUser?.thursday == null;
        break;
      case 'friday':
        result = currentUser?.friday == null;
        break;
      case 'sunday':
        result = currentUser?.sunday == null;
        break;
      case 'saturday':
        result = currentUser?.saturday == null;
        break;
      default:
        result = false;
        break;
    }
    return result;
  }

  String getWeekDayString() {
    DateTime now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  Widget buildContentForIndex(int index) {
    switch (index) {
      case 0:
        return TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (await ifExerciseIsEmpty(getWeekDayString())) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("No routine"),
                      content:
                          const Text("Add routine, or take a rest today :)"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TodayRoutine()));
              }
            },
            child: Text("Start your ${getWeekDayString()} routine",
                style: const TextStyle(color: Colors.white)));
      case 1:
        return TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WeekDayGraph()));
            },
            child: Text("Look your ${getWeekDayString()} routine graph",
                style: const TextStyle(color: Colors.white)));
      case 2:
        return TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShowAllData()));
            },
            child: const Text("Look at your all routines history",
                style: TextStyle(color: Colors.white)));
      default:
        return const Text("Wrong()");
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(
      3,
      (index) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: SizedBox(
          height: 200,
          child: Center(
            child: buildContentForIndex(index),
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: pages.length,
                effect: const SwapEffect(
                    dotHeight: 16,
                    dotWidth: 16,
                    type: SwapType.yRotation,
                    dotColor: Colors.black,
                    activeDotColor: Colors.orange),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 400.0,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                      ),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                              child: GestureDetector(
                                onTap: () => {},
                                child: Column(
                                  children: <Widget>[
                                    Image.network(
                                      (newsResponse.articles.isNotEmpty)
                                          ? newsResponse
                                                  .articles[i].urlToImage ??
                                              "https://res.cloudinary.com/practicaldev/image/fetch/s--wnl5nbWu--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/7kwc5kbz97o2ui9utneu.png"
                                          : "https://res.cloudinary.com/practicaldev/image/fetch/s--wnl5nbWu--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/7kwc5kbz97o2ui9utneu.png",
                                    ),
                                    if (newsResponse.articles.isNotEmpty)
                                      Text(
                                        newsResponse.articles[i].title,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    if (newsResponse.articles.isNotEmpty)
                                      Text(
                                        newsResponse.articles[i].description,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
