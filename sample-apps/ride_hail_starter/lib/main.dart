import 'package:flutter/material.dart';

import 'pages/role_home.dart';

void main() {
  runApp(const RideHailApp());
}

class RideHailApp extends StatelessWidget {
  const RideHailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Hail Starter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const RoleHome(),
    );
  }
}
