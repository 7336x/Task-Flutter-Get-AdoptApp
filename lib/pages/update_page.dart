import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatefulWidget {
  final Pet pet;

  const UpdatePage({Key? key, required this.pet}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late int age;
  late String gender;

  @override
  void initState() {
    super.initState();
    // Initialize the fields with the current pet data
    name = widget.pet.name;
    age = widget.pet.age;
    gender = widget.pet.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Pet'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the pet's name";
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                initialValue: age.toString(),
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the pet's age";
                  } else if (int.tryParse(value) == null) {
                    return "Please enter a valid number for age";
                  }
                  return null;
                },
                onSaved: (value) {
                  age = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the pet's gender";
                  }
                  return null;
                },
                onSaved: (value) {
                  gender = value!;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Call the updatePet method from the provider
                      Provider.of<PetsProvider>(context, listen: false)
                          .updatePet(
                        Pet(
                          id: widget.pet.id, // Ensure to include the pet ID
                          name: name,
                          age: age,
                          gender: gender,
                          image: widget.pet.image, // Keep the original image
                        ),
                      );

                      Navigator.of(context).pop(); // Go back after updating
                    }
                  },
                  child: const Text("Update Pet"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
