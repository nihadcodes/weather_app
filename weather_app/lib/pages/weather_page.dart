import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('61885be3a9b2e52ba28fdd53e3678516');
  Weather? _weather;

//fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentcity();


    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }


    //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if(mainCondition == null)
      return 'assets/sunny.json'; //default to sunny
    switch(mainCondition.toLowerCase()){
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

    // init state
    @override
    void initState() {
      super.initState();

      //fetch weather on startup
      _fetchWeather();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City name with location icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.location_on,
                      color: Colors.red
                  ), // Location icon
                  SizedBox(width: 5), // Spacing between icon and text
                  Text(_weather?.cityName ?? "loading city..."),
                ],
              ),

              // Animation
              Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

              // Temperature in bold
              Text(
                '${_weather?.temperature.round()}°C',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make temperature bold
                  fontSize: 24, // Adjust font size if needed
                ),
              ),

              // Weather condition
              Text(_weather?.mainCondition ?? ""),
            ],
          ),
        ),
      );
    }
  }






