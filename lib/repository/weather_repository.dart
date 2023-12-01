import 'package:weather_app/models/custom_error.dart';
import 'package:weather_app/models/direct_geocoding.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;
  WeatherRepository({required this.weatherApiServices});

  Future<Weather> fetchWeather(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);
      print("directGeocoding: $directGeocoding");

      final Weather currentWeather =
          await weatherApiServices.getWeather(directGeocoding);

      final Weather weather = currentWeather.copyWith(
          name: directGeocoding.name, country: directGeocoding.country);

      return weather;
    } catch (error) {
      throw CustomError(errorMessage: error.toString());
    }
  }
}
