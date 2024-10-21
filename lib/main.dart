import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/pages/home_page.dart';
import 'package:adopt_app/pages/update_page.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:adopt_app/pages/add_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PetsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/add_page',
        builder: (context, state) => const AddPage(),
      ),
      GoRoute(
        path: '/update/:petId',
        builder: (context, state) {
          final petId = state.pathParameters['petId']!;
          // Fetch the pet using the petId from the provider
          return FutureBuilder<Pet>(
            future: Provider.of<PetsProvider>(context, listen: false)
                .getPetById(petId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final pet = snapshot.data!;
                return UpdatePage(pet: pet); // Pass the pet to the UpdatePage
              } else {
                return const Center(child: Text('Pet not found.'));
              }
            },
          );
        },
      ),
    ],
  );
}
