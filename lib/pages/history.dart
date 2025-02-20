import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibration_sensor/provider/data_gempa.dart';

class FirestoreDetailScreen extends StatefulWidget {
  final String docId;

  FirestoreDetailScreen({required this.docId});

  @override
  _FirestoreDetailScreenState createState() => _FirestoreDetailScreenState();
}

class _FirestoreDetailScreenState extends State<FirestoreDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<Map<String, dynamic>?> _documentData;

  @override
  void initState() {
    super.initState();
    _documentData = _firestoreService.getGempaById(widget.docId);
  }

  // Widget custom untuk menampilkan informasi detail dengan style serupa
  Widget buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF3A3A4F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 30),
          SizedBox(width: 16),
          Expanded(
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
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2C),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Header yang mirip dengan halaman utama
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      SizedBox(height: 4),
                      Text(
                        'Detail Gempa',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Menampilkan detail gempa
              Expanded(
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: _documentData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                        child: Text(
                          'Dokumen tidak ditemukan.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    var data = snapshot.data!;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          buildInfoTile(
                            FontAwesomeIcons.calendar,
                            "Tanggal",
                            data['Infogempa']['gempa']['Tanggal'] ?? "N/A",
                          ),
                          buildInfoTile(
                            FontAwesomeIcons.clock,
                            "Waktu",
                            data['Infogempa']['gempa']['Jam'] ?? "N/A",
                          ),
                          buildInfoTile(
                            FontAwesomeIcons.mapMarkerAlt,
                            "Koordinat",
                            data['Infogempa']['gempa']['Coordinates'] ?? "N/A",
                          ),
                          buildInfoTile(
                            FontAwesomeIcons.ruler,
                            "Kedalaman",
                            data['Infogempa']['gempa']['Kedalaman'] ?? "N/A",
                          ),
                          buildInfoTile(
                            FontAwesomeIcons.waveSquare,
                            "Magnitude",
                            data['Infogempa']['gempa']['Magnitude'].toString(),
                          ),
                          buildInfoTile(
                            FontAwesomeIcons.users,
                            "Dirasakan",
                            data['Infogempa']['gempa']['Dirasakan'] ?? "N/A",
                          ),
                          buildInfoTile(
                            FontAwesomeIcons.exclamationTriangle,
                            "Potensi",
                            data['Infogempa']['gempa']['Potensi'] ?? "N/A",
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
