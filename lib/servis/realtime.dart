import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>> getDataFromFirebase() async {
  const String firebaseUrl =
      'https://sgproject-4c7ed-default-rtdb.firebaseio.com/Simulation/SensorModule.json';

  try {
    final response = await http.get(Uri.parse(firebaseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return {
        'notifCondition': data['notifCondition'] ?? "Data tidak ditemukan",
         'valueCondition': data['valueCondition'] ?? "Data tidak ditemukan",
      };
    } else {
      return {
        'notifCondition': "Gagal mengambil data.",
         'valueCondition': "Gagal mengambil data.",
      };
    }
  } catch (e) {
    print('Error: $e');
    return {
      'notifCondition': "Terjadi kesalahan.",
      'valueCondition': "Terjadi kesalahan.",
    };
  }
}
