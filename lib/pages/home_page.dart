import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:recase/recase.dart";
import "package:weather_app/constants/constants.dart";
import "package:weather_app/cubits/temp_settings/temp_settings_cubit.dart";
import "package:weather_app/cubits/weather/weather_cubit.dart";
import "package:weather_app/pages/search_page.dart";
import "package:weather_app/widgets/error_dialog.dart";

import "settings_page.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              _city = await Navigator.push(
                //city name is returned from the pop function on the search page which has the form
                context,
                MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }),
              );
              print(_city);
              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            },
          ),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SettingPage();
                }));
              })
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;
    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + "℉";
    } else {
      return temperature.toStringAsFixed(2) + "℃";
    }
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
        placeholder: "",
        image: 'https://$kIconHost/img/wn/$icon@4x.png',
        width: 96,
        height: 96);
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(builder: (context, state) {
      if (state.status == WeatherStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.status == WeatherStatus.loaded) {
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  "(${state.weather.country})",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${showTemperature(state.weather.temp)}",
                  style: const TextStyle(
                      fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20.0),
                Column(
                  children: [
                    Text(
                      "${showTemperature(state.weather.tempMax)}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "${showTemperature(state.weather.tempMin)}",
                      style: TextStyle(fontSize: 16.0),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 40.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showIcon(state.weather.icon),
                formatText(state.weather.description),
              ],
            )
          ],
        );
      }

      if (state.status == WeatherStatus.error ||
          state.status == WeatherStatus.initial) {
        return const Center(
            child: Text(
          "Select A City",
          style: TextStyle(fontSize: 20.0),
        ));
      }

      return Container();
    }, listener: (context, state) {
      if (state.status == WeatherStatus.error) {
        errorDialog(context, state.error.errorMessage);
      }
    });
  }
}
