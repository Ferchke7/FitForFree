class WeatherForecast {
  final DateTime date;
  final int temperatureC;
  final String summary;

  WeatherForecast({
    required this.date,
    required this.temperatureC,
    required this.summary,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date']),
      temperatureC: json['temperatureC'],
      summary: json['summary'],
    );
  }
}
