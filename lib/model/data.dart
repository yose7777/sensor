import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vibration_sensor/pages/history.dart';
import 'package:vibration_sensor/provider/data_gempa.dart';

class FirestoreDataScreen extends StatefulWidget {
  @override
  _FirestoreDataScreenState createState() => _FirestoreDataScreenState();
}

class _FirestoreDataScreenState extends State<FirestoreDataScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<Map<String, dynamic>>> _gempaData;

  @override
  void initState() {
    super.initState();
    _gempaData = _firestoreService.getGempaData();
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
              // Header dengan tampilan mirip HomePage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      SizedBox(height: 4),
                      Text(
                        'Data Gempa Menurut BMKG',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Tombol kembali
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Menampilkan data gempa dalam list
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _gempaData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada data.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }
                    var gempaList = snapshot.data!;
                    return ListView.builder(
                      itemCount: gempaList.length,
                      itemBuilder: (context, index) {
                        var documentData = gempaList[index];
                        String docId = documentData['id'] ?? 'Unknown';

                        return GempaCard(
                          docId: docId,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FirestoreDetailScreen(docId: docId),
                              ),
                            );
                          },
                        );
                      },
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

class GempaCard extends StatelessWidget {
  final String docId;
  final VoidCallback onTap;

  const GempaCard({Key? key, required this.docId, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF3A3A4F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.earthAsia, color: Colors.redAccent, size: 30),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   "Wilayah Gempa:                                                         $docId",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Klik untuk melihat detail",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
