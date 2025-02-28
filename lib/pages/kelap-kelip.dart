import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration_sensor/pages/home.dart';

class DangerScreen extends StatefulWidget {
  @override
  _DangerScreenState createState() => _DangerScreenState();
}

class _DangerScreenState extends State<DangerScreen> {
  bool _isRed = true;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
    _autoCloseScreen();
  }

  void _startBlinking() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _isRed = !_isRed;
        });
      }
    });
  }

  void _autoCloseScreen() {
    Future.delayed(const Duration(seconds: 5), () {
      _blinkTimer?.cancel(); // Hentikan kelap-kelip sebelum pindah layar
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel(); // Pastikan timer dihentikan saat screen ditutup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isRed ? Colors.red : Colors.black, // Kelap-kelip merah & hitam
      body: Center(
        child: Text(
          "⚠ BAHAYA TERDETEKSI! ⚠",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
