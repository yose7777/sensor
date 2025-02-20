import 'package:flutter/material.dart';
import 'package:vibration_sensor/servis/servis_cuaca.dart';
import 'package:vibration_sensor/model/cuaca.dart';

class WeatherProvider with ChangeNotifier {
  WeatherModel? _weather;
  bool _isLoading = false;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;

  Future<void> loadWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      _weather = await WeatherService().fetchWeather();
    } catch (e) {
      _weather = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
