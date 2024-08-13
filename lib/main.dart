import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?q=qena&appid=979e237b0f5e09e3c71616ac4781af58&units=metric';
  Map<String, dynamic> weatherData = {};

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: weatherData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${weatherData['main']['temp']}°C',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildWeatherCard(
                        'Humidity',
                        '${weatherData['main']['humidity']}%',
                      ),
                      _buildWeatherCard(
                        'Feels Like',
                        '${weatherData['main']['feels_like']}°C',
                      ),
                      _buildWeatherCard(
                        'Visibility',
                        '${weatherData['visibility']} m',
                      ),
                      _buildWeatherCard(
                        'Wind Speed',
                        '${weatherData['wind']['speed']} m/s',
                      ),
                      _buildWeatherCard(
                        'Sunrise',
                        _formatTime(weatherData['sys']['sunrise']),
                      ),
                      _buildWeatherCard(
                        'Sunset',
                        _formatTime(weatherData['sys']['sunset']),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildWeatherCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int timestamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.hour}:${date.minute}';
  }
}
