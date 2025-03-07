import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration_sensor/model/data.dart';
import 'package:vibration_sensor/servis/auth_service.dart';
import 'package:vibration_sensor/servis/realtime.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String notifCondition = "Memuat data..."; // Menyimpan data yang diambil
 String valueCondition = "Memuat data..."; // Menyimpan data yang diambil
 

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  void _startPolling() {
    Future.delayed(const Duration(seconds: 1), () {
      _getData();
      _startPolling();
    });
  }

Future<void> _getData() async {
  Map<String, dynamic> data = await getDataFromFirebase();
  setState(() {
    notifCondition = data['notifCondition']; // Menampilkan string
    valueCondition = data['valueCondition']; // Menampilkan number
  });
}
  // Fungsi untuk menampilkan dialog konfirmasi log out
  Future<bool> _showLogoutDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Menonaktifkan penutupan dialog dengan klik di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Menutup dialog dan mengembalikan 'Tidak'
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Menutup dialog dan mengembalikan 'Ya'
              },
              child: Text('Ya, Keluar'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Jika dialog ditutup tanpa memilih, kembalikan 'false'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2C),
      body: Padding(
        padding: EdgeInsets.all(20), // Fixed padding
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20), // Fixed padding
              decoration: BoxDecoration(
                color: Color(0xFF2C2C3E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SMK LEONARDO',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'NAMA APLIKASI',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          // Menampilkan dialog konfirmasi
                          bool shouldLogout = await _showLogoutDialog(context);
                          if (shouldLogout) {
                            await AuthProvider().logout();
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                        child: Icon(Icons.logout_sharp, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF3A3A4F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifCondition, // Menampilkan data yang diambil
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Kondisi Rumah',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              valueCondition, // Menampilkan data yang diambil
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Besaran Getar',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            LottieBuilder.asset(
                              'assets/1sfty.json',
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'INDIKASI',
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data Menurut BMKG',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Gunakan PageView untuk menampilkan setiap card sebagai halaman
                  Container(
                    height: 300,  // Tentukan tinggi halaman sesuai kebutuhan
                    child: PageView(
                      children: [
                        // Halaman pertama untuk Alat Pemantau Kondisi Rumah
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8), // Jarak antar card
                          child: DeviceCard(
                            title: 'Alat Pemantau Kondisi Rumah',
                            description:
                                'Pada alat ini, Anda akan mendapatkan informasi terkini mengenai kondisi rumah Anda, seperti suhu, tekanan udara, dan berbagai informasi penting lainnya yang dapat membantu Anda menjaga kenyamanan dan keamanan di rumah.',
                          ),
                        ),
                        // Halaman kedua untuk informasi tambahan
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8), // Jarak antar card
                          child: DeviceCard(
                            title: 'Peringatan Dini',
                            description:
                                'Dengan menggunakan alat pemantau ini, Anda akan mendapatkan peringatan dini apabila terjadi perubahan kondisi yang tidak normal di rumah Anda, sehingga Anda bisa segera melakukan tindakan preventif.',
                          ),
                        ),
                        // Halaman ketiga untuk informasi lainnya
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8), // Jarak antar card
                          child: DeviceCard(
                            title: 'Pemeliharaan Alat',
                            description:
                                'Alat pemantau ini memerlukan pemeliharaan rutin untuk memastikan kinerjanya tetap optimal. Pastikan untuk membersihkan sensor secara berkala dan memeriksa konektivitas alat.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            BottomNavigationBar(),
          ],
        ),
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String title;
  final String description;

  DeviceCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF3A3A4F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          SingleChildScrollView(
            child: Text(
              description,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF2C2C3E),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
  icon: Icon(Icons.work_history_outlined, color: Colors.grey),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FirestoreDataScreen()),
    );
  },
),

          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,       
            ),
            child: Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
