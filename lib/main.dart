import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;
import "package:weather_app/cubits/temp_settings/temp_settings_cubit.dart";
import "package:weather_app/cubits/theme/theme_cubit.dart";
import "package:weather_app/cubits/weather/weather_cubit.dart";
import "package:weather_app/pages/home_page.dart";
import "package:weather_app/repository/weather_repository.dart";
import "package:weather_app/services/weather_api_services.dart";

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiServices: WeatherApiServices(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
                weatherRepository: context.read<WeatherRepository>()),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(
              weatherCubit: context.read<WeatherCubit>(),
            ),
          )
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) => MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            theme: state.appTheme == AppTheme.LIGHT
                ? ThemeData.light()
                : ThemeData.dark(),
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}
