import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl;

  WeatherService(this.baseUrl);

  Future<List<WeatherForecast>> getWeatherForecast() async {
    final response = await http.get(Uri.parse('$baseUrl/weatherforecast'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => WeatherForecast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }
}

class WeatherForecast {
  final DateTime date;
  final int temperatureC;
  final String summary;

  WeatherForecast({required this.date, required this.temperatureC, required this.summary});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date']),
      temperatureC: json['temperatureC'],
      summary: json['summary'],
    );
  }
}
