import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:vibration_sensor/model/cuaca.dart';

class WeatherService {
  static const String apiKey = 'e97a8e76b5a3fda53767ede458ae5bed'; // Ganti dengan API Key Anda
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather() async {
    Position position = await _getCurrentLocation();
    final url = '$baseUrl?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey&lang=id';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mendapatkan data cuaca');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Layanan lokasi tidak diaktifkan");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Izin lokasi ditolak");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Izin lokasi ditolak permanen");
    }

    return await Geolocator.getCurrentPosition();
  }
}
