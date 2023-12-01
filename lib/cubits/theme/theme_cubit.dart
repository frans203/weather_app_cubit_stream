import "dart:async";

import "package:equatable/equatable.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:weather_app/constants/constants.dart";
import "package:weather_app/cubits/weather/weather_cubit.dart";

part "theme_state.dart";

class ThemeCubit extends Cubit<ThemeState> {
  late final StreamSubscription weatherSubscription;
  final WeatherCubit weatherCubit;
  ThemeCubit({required this.weatherCubit}) : super(ThemeState.initial()) {
    weatherSubscription = weatherCubit.stream.listen((WeatherState weatherState) {
      print("WeatherState: $weatherState");

      if(weatherState.weather.temp >  kWarmOrNot){
        emit(state.copyWith(appTheme: AppTheme.LIGHT));
      }else{
        emit(state.copyWith(appTheme: AppTheme.DARK));
      }
    });
  }

  void toggleTheme() {
    emit(state.copyWith(
        appTheme:
            state.appTheme == AppTheme.LIGHT ? AppTheme.DARK : AppTheme.LIGHT));
  }

  @override
  Future<void> close() {
    weatherSubscription.cancel();
    return super.close();
  }
}
