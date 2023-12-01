import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:weather_app/models/custom_error.dart";
import "package:weather_app/models/weather.dart";
import "package:weather_app/repository/weather_repository.dart";

part "weather_state.dart";

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository})
      : super(WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final Weather weather = await weatherRepository.fetchWeather(city);

      emit(state.copyWith(status: WeatherStatus.loaded, weather: weather));
      print("state: $state");
    } on CustomError catch (error) {
      emit(state.copyWith(error: error, status: WeatherStatus.error));
      print("state: $state");
    }
  }
}
