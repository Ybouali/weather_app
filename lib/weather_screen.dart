import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/secret.dart';
import 'package:weather_app/widget/additinal_info_item.dart';
import 'package:weather_app/widget/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/widget/message.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late TextEditingController _controller;
  late String _city;
  final InfoAppMessages messages = InfoAppMessages();
  late bool isLoddedData = true;
  late String messageError = "";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _city = 'Errachidia';
    getCurrentWeather();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$_city&APPID=$openWeatherApiKey',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter Ur City'),
          content: SingleChildScrollView(
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'name of the city',
              ),
              controller: _controller,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: submit,
              child: const Text('Submit'),
            )
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop(_controller.text);
  }

  void onPressedButtonChangeCity() async {
    // show the popup menu to set the name of the city
    final cityName = await openDialog();

    if (cityName == null || cityName.isEmpty) {
      // here i will show a error message popup
      messageError = 'Next Time Enter Something HHHHHHHHHHHHHHHHHH';
      return;
    }

    _city = cityName.toString().toLowerCase();
    setState(() {});
  }

  bool isDarkMode = true;

  void changeMode() {
    isDarkMode = !isDarkMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: changeMode,
            icon: isDarkMode
                ? const Icon(Icons.sunny)
                : const Icon(Icons.nightlight_round),
          ),
          title: ElevatedButton(
            onPressed: onPressedButtonChangeCity,
            child: Text(
              _city,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            final data = snapshot.data!;

            final currentWeatherData = data['list'][0];

            final currentTemp = currentWeatherData['main']['temp'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currentPressure = currentWeatherData['main']['pressure'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // main content
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp °K',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              currentSky == 'clouds' || currentSky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              '$currentSky',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // weather information
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];

                        final hounlySky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final temp = hourlyForecast['main']['temp'].toString();

                        final time =
                            DateTime.parse(hourlyForecast['dt_txt'].toString());
                        return HourlyForCastItem(
                          time: DateFormat.j().format(time),
                          temperature: temp,
                          icon: hounlySky == 'Clouds' || hounlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // additional information
                  const Text(
                    'Additional information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditinalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentPressure.toString(),
                      ),
                      AdditinalInfoItem(
                        icon: Icons.air,
                        label: 'Wind speed',
                        value: currentPressure.toString(),
                      ),
                      AdditinalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
