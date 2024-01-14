import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skysense/models/weather_model.dart';
import 'package:skysense/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('ff3d783024ea2a3c2dee6d198db430a9');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //fetch weather for that city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Icon(Icons.location_on,color: Colors.black,size:30),

              const SizedBox(
                height: 4,
              ),

              //city Name
              Text(
                _weather?.cityName ?? "Loading city...",
                style: const TextStyle(
                    fontSize: 30,
                    fontFamily: 'Mukta',
                    fontWeight: FontWeight.bold,color: Colors.black),
              ),

              const SizedBox(
                height: 64,
              ),

              //animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              const SizedBox(
                height: 64,
              ),

              //Temperature
              Text("${_weather?.temperature.round()}°C",
                  style: const TextStyle(fontSize: 50, fontFamily: 'Kanit',color: Colors.black)),

              Text(_weather?.mainCondition ?? "")
            ],
          ),
        ));
  }
}
