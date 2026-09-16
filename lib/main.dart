import 'package:flutter/material.dart';

import 'core/constants/routes.dart';
import 'data/data.dart';
import 'models/trip.dart';
import 'screens/home/home.dart';
import 'screens/payment/payment.dart';
import 'screens/trip_detail/trip_detail.dart';

void main() {
  runApp(const VietwayApp());
}

class VietwayApp extends StatelessWidget {
  const VietwayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vietway',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007C73)),
      ),

      initialRoute: AppRoutes.home,

      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.tripDetail: (context) {
          final trip = ModalRoute.of(context)?.settings.arguments as Trip?;
          return TripDetailScreen(trip: trip ?? TripData.demoTrip);
        },
        AppRoutes.payment: (context) {
          final trip = ModalRoute.of(context)?.settings.arguments as Trip?;
          return PaymentScreen(trip: trip ?? TripData.demoTrip);
        },
      },
    );
  }
}
