import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/secret.dart';
import 'package:weather_app/widget/additinal_info_item.dart';
import 'package:weather_app/widget/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/widget/message.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class DataWeather {}

class _WeatherScreenState extends State<WeatherScreen> {
  late TextEditingController _controller;
  late String _city;
  late String _oldCityName;
  final InfoAppMessages messages = InfoAppMessages();
  late bool isError = false;
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

  Future getCurrentWeather() async {
    final res = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$_city&APPID=$openWeatherApiKey',
      ),
    );

    final data = jsonDecode(res.body);

    if (data['cod'] != '200') {
      isError = true;
      messageError = data['message'];
    }
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Enter Ur City'),
          content: SingleChildScrollView(
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(hintText: 'name of the city'),
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
      isError = true;
      messageError = 'Next Time Enter Something HHHHHHHHHHHHHHHHHH';
      return;
    }

    _oldCityName = _city;

    _city = cityName;

    getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    // if (isError) {
    //   _city = _oldCityName;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: messages.showMessage(
    //         InfoAppMessageType.warn,
    //         "DON'T TOUCH ME AGAIN",
    //       ),
    //       backgroundColor: Colors.transparent,
    //     ),
    //   );
    //   isError = false;
    //   messageError = "";
    //   setState(() {});
    // }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: ElevatedButton(
          onPressed: () {
            onPressedButtonChangeCity();
            getCurrentWeather();
            setState(() {});
          },
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: messages.showMessage(
                    InfoAppMessageType.warn,
                    "DON'T TOUCH ME AGAIN",
                  ),
                  backgroundColor: Colors.transparent,
                ),
              );
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
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
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        '300 °F',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.cloud,
                        size: 64,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Rain',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
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
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForCastItem(
                    time: '03:00',
                    temperature: '301.01',
                    icon: Icons.cloud,
                  ),
                  HourlyForCastItem(
                    time: '04:00',
                    temperature: '301.01',
                    icon: Icons.sunny,
                  ),
                  HourlyForCastItem(
                    time: '05:00',
                    temperature: '301.01',
                    icon: Icons.cloud,
                  ),
                  HourlyForCastItem(
                    time: '06:00',
                    temperature: '301.01',
                    icon: Icons.sunny,
                  ),
                  HourlyForCastItem(
                    time: '07:00',
                    temperature: '301.01',
                    icon: Icons.cloud,
                  ),
                  HourlyForCastItem(
                    time: '08:00',
                    temperature: '301.01',
                    icon: Icons.sunny,
                  ),
                  HourlyForCastItem(
                    time: '09:00',
                    temperature: '301.01',
                    icon: Icons.cloud,
                  ),
                ],
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditinalInfoItem(
                  icon: Icons.water_drop,
                  label: 'Humidity',
                  value: '96',
                ),
                AdditinalInfoItem(
                  icon: Icons.air,
                  label: 'Wind speed',
                  value: '96',
                ),
                AdditinalInfoItem(
                  icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '96',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
