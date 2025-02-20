import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>> getDataFromFirebase() async {
  const String firebaseUrl =
      'https://sgproject-4c7ed-default-rtdb.firebaseio.com/aman.json';

  try {
    final response = await http.get(Uri.parse(firebaseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      return {
        'notif': data['notif'] ?? "Data tidak ditemukan",
      };
    } else {
      return {
        'notif': "Gagal mengambil data.",
      };
    }
  } catch (e) {
    print('Error: $e');
    return {
      'notif': "Terjadi kesalahan.",
    };
  }
}
