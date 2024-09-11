import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
        Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(('failed to load weather data'));
    }
  }

    Future<String> getCurrentcity() async {
      // get permission from user
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      // fetch the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);


      // convert the location into a list of place mark objects
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      // extra the city name from the first place mark
      String? city = placemarks[0].locality;

      return city ?? '';
    }
    }



