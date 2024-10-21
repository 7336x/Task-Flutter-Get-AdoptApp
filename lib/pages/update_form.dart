import 'dart:io';
import 'package:adopt_app/models/pet.dart';
import 'package:adopt_app/providers/pets_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UpdatePetForm extends StatefulWidget {
  final Pet pet;
  UpdatePetForm({required this.pet});

  @override
  _UpdatePetFormState createState() => _UpdatePetFormState();
}

class _UpdatePetFormState extends State<UpdatePetForm> {
  final _formKey = GlobalKey<FormState>();
  var _image;
  String title = "";
  int age = 0; // Assuming you have an integer field for age
  String gender = ""; // Assuming you have a string field for gender
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Pet Name',
            ),
            initialValue: widget.pet.name,
            validator: (value) {
              if (value!.isEmpty) {
                return "please fill out this field";
              }
              return null;
            },
            onSaved: (value) {
              title = value!;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Pet Age',
            ),
            initialValue: widget.pet.age.toString(),
            validator: (value) {
              if (value == null) {
                return "please enter an age";
              } else if (int.tryParse(value) == null) {
                return "please enter a valid number";
              }
              return null;
            },
            onSaved: (value) {
              age = int.parse(value!);
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Pet Gender',
            ),
            initialValue: widget.pet.gender,
            validator: (value) {
              if (value!.isEmpty) {
                return "please fill out this field";
              }
              return null;
            },
            onSaved: (value) {
              gender = value!;
            },
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = File(image!.path);
                  });
                },
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Colors.blue[200]),
                  child: _image != null
                      ? Image.file(
                          _image,
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.fitHeight,
                        )
                      : Container(
                          decoration: BoxDecoration(color: Colors.blue[200]),
                          width: 200,
                          height: 200,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Image"),
              )
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Create a new Pet object with the updated information
                  final updatedPet = Pet(
                    id: widget.pet.id, // Ensure you are using the correct id
                    name: title, // Using the name from the form
                    age: age, // Using the age from the form
                    gender: gender, // Using the gender from the form
                    image: _image?.path ??
                        widget.pet
                            .image, // Use the new image if picked, else retain the old one
                  );

                  // Call the updatePet function in the provider
                  Provider.of<PetsProvider>(context, listen: false)
                      .updatePet(updatedPet);

                  // Pop the current page
                  GoRouter.of(context).pop();
                }
              },
              child: const Text("Update Pet"),
            ),
          ),
        ],
      ),
    );
  }
}
