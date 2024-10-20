import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:adopt_app/widgets/pet_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Pet> pets = Provider.of<PetsProvider>(context).pets;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Adopt"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Add a new Pet"),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<PetsProvider>(context, listen: false)
                    .getPetsWithNotify();
              },
              child: const Text("GET"),
            ),
            FutureBuilder<List<Pet>>(
              future:
                  Provider.of<PetsProvider>(context, listen: false).getPets(),
              builder: (context, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (dataSnapshot.hasError) {
                  return Center(child: Text('Error: ${dataSnapshot.error}'));
                } else if (dataSnapshot.hasData) {
                  List<Pet> pets = dataSnapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height),
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pets.length,
                    itemBuilder: (context, index) => PetCard(pet: pets[index]),
                  );
                } else {
                  return const Center(child: Text('No pets available'));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
