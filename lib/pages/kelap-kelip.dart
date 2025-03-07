import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DangerScreen extends StatefulWidget {
  @override
  _DangerScreenState createState() => _DangerScreenState();
}

class _DangerScreenState extends State<DangerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Kecepatan kelap-kelip
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: Colors.red.withOpacity(0.2),
      end: Colors.red.withOpacity(0.8),
    ).animate(_controller);


    
  }




  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _animation.value,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/ani.json', width: 150, height: 150), // Animasi bahaya
                SizedBox(height: 20),
                Text(
                  "BAHAYA TERDETEKSI!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Kembali"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
