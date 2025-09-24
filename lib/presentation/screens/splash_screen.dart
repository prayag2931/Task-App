import 'package:flutter/material.dart';
import 'package:task_app/core/theme/text_style.dart';
import 'package:task_app/presentation/screens/task_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
   Future.delayed(const Duration(seconds: 2), () {
     Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (context) => const TaskListScreen()),
     );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
         
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            Image.asset( 'assets/images/task.png', height: 150, width: 150, ),
            Text(
              'Task App',
              style: AppTextStyle.lightBodyLargeBold,
            ),
          ],
        ),
      ),
    );
  }
}