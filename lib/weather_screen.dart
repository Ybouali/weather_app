import 'package:flutter/material.dart';
import 'package:weather_app/widget/additinal_info_item.dart';
import 'package:weather_app/widget/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  Future getCurrentWeather() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print('hello');
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
