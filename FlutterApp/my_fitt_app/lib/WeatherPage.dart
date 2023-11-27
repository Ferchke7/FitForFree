// weather_page.dart

import 'package:flutter/material.dart';
import 'package:my_fitt_app/WeatherForecast.dart';

class WeatherPage extends StatelessWidget {
  final List<WeatherForecast> weatherData;

  WeatherPage({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Data'),
      ),
      body: ListView.builder(
        itemCount: weatherData.length,
        itemBuilder: (context, index) {
          var forecast = weatherData[index];
          return ListTile(
            title: Text('Date: ${forecast.date}'),
            subtitle: Text('Temperature: ${forecast.temperatureC}°C'),
          );
        },
      ),
    );
  }
}
