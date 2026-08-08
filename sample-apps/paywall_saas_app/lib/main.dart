import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'state/entitlements.dart';
import 'state/notes_controller.dart';

void main() {
  runApp(const PaywallSaasApp());
}

class PaywallSaasApp extends StatelessWidget {
  const PaywallSaasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Entitlements()..load()),
        ChangeNotifierProvider(create: (_) => NotesController()),
      ],
      child: MaterialApp(
        title: 'Paywall SaaS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
