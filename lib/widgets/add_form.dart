import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:adopt_app/providers/pets_provider.dart'; // Import your pets provider
import 'package:adopt_app/models/pet.dart'; // Import your Pet model

final _picker = ImagePicker();

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  // Create a GlobalKey for the form
  final _formKey = GlobalKey<FormState>();
  XFile? _image; // Variable to hold the selected image

  // Variables to hold our form data
  String _petName = '';
  int _petAge = 0;
  String _gender = ''; // Variable for gender selection

  // Controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image; // Update the state with the selected image
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _submitData() {
    // Run validation when the submit button is pressed
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Call save to assign values to variables

      // Create a new Pet object
      Pet newPet = Pet(
        name: _petName,
        age: _petAge,
        gender: _gender,
        image:
            _image != null ? File(_image!.path).path : '', // Assign image path
      );

      // Use the provider to create a new pet
      Provider.of<PetsProvider>(context, listen: false).createPet(newPet);

      // Handle the data (e.g., send it to your server or save it locally)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Adding Pet: $_petName, Age: $_petAge,  Gender: $_gender'),
        ),
      );

      // Optionally, clear the form after submission
      _nameController.clear();
      _ageController.clear();

      setState(() {
        _gender = ''; // Reset the gender selection
        _image = null; // Reset the selected image
      });

      // Pop the screen to return to the home page
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Assign the global key to the Form widget
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pet Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Pet Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the pet name';
                }
                return null;
              },
              onSaved: (value) {
                _petName = value ?? ''; // Assign value to _petName
              },
            ),
            const SizedBox(height: 16.0),

            // Pet Age field
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Pet Age',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the pet age';
                }
                final intValue = int.tryParse(
                    value); // Try parse to check if it is int or not
                if (intValue == null) {
                  return 'Please enter a valid integer for age';
                }
                return null;
              },
              onSaved: (value) {
                _petAge =
                    int.tryParse(value ?? '') ?? 0; // Assign value to _petAge
              },
            ),
            const SizedBox(height: 16.0),

            // Gender Selection
            DropdownButtonFormField<String>(
              value: _gender.isNotEmpty ? _gender : null,
              decoration: const InputDecoration(
                labelText: 'Pet Gender',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'male',
                  child: Text('Male'),
                ),
                DropdownMenuItem(
                  value: 'female',
                  child: Text('Female'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _gender = value ?? ''; // Update gender variable
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a gender';
                }
                return null;
              },
              onSaved: (value) {
                _gender = value ?? ''; // Assign value to _gender
              },
            ),
            const SizedBox(height: 16.0),

            // Image selection
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(color: Colors.blue[200]),
                child: _image == null
                    ? const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      )
                    : Image.file(
                        File(_image!.path),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Select Image"),
            ),
            const SizedBox(height: 16.0),

            // Submit button
            ElevatedButton(
              onPressed: () {
                _submitData(); // Call the submit function
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
