import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mengambil semua dokumen dalam koleksi 'gempa'
  Future<List<Map<String, dynamic>>> getGempaData() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('gempa').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Simpan ID dokumen
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching data: $e");
      return [];
    }
  }

  // Mengambil data berdasarkan ID dokumen
  Future<Map<String, dynamic>?> getGempaById(String docId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('gempa').doc(docId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching document: $e");
      return null;
    }
  }
}
