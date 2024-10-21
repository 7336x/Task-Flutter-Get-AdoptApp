import 'package:adopt_app/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Ensure you import Dio

class DioClient {
  final Dio _dio = Dio();

  Future<List<Pet>> getPets() async {
    List<Pet> pets = [];
    try {
      Response response =
          await _dio.get("https://coded-pets-api-crud.eapi.joincoded.com/pets");
      pets = (response.data as List).map((pet) => Pet.fromJson(pet)).toList();
    } on DioError catch (error) {
      print(error);
    }
    return pets;
  }

  // Function to add a pet
  Future<Pet> createPet(Pet pet) async {
    late Pet newPet; // Declare a late variable to hold the new Pet

    try {
      // Create FormData from the pet data
      FormData data = FormData.fromMap({
        'name': pet.name,
        'age': pet.age,
        'gender': pet.gender,
        // Add other properties as needed, such as an image file if required
      });

      // Send a POST request to the specified endpoint
      Response response = await _dio.post(
        "https://coded-pets-api-crud.eapi.joincoded.com/pets",
        data: data, // Pass the FormData
      );

      newPet = Pet.fromJson(
          response.data); // Assign response data to the newPet variable
    } on DioError catch (error) {
      print("Error adding pet: $error");
      throw Exception(
          'Failed to add pet: ${error.message}'); // Handle the error accordingly
    }

    return newPet; // Return the created Pet object
  }
}

class PetsProvider extends ChangeNotifier {
  List<Pet> pets = [
    Pet(
      name: "Lucifurr",
      image: "https://i.ibb.co/P6VJ4pZ/smile-cat-1.png",
      age: 2,
      gender: "male",
    ),
  ];

  // Fetch pets from the API
  Future<List<Pet>> getPets() async {
    pets = await DioClient().getPets();
    return pets;
  }

  // Fetch pets and notify listeners
  Future<List<Pet>> getPetsWithNotify() async {
    pets = await DioClient().getPets();
    notifyListeners();
    return pets;
  }

  // Function to create a new pet
  Future<void> createPet(Pet toAdd) async {
    try {
      // Call the service to create the pet
      Pet newPet =
          await DioClient().createPet(toAdd); // Fixed the parameter name

      // Insert the new pet into the list of pets
      pets.add(newPet); // Adds the newly created pet to the local pets list

      // Notify listeners to update the UI
      notifyListeners(); // Ensure the UI updates with the new pet
    } catch (error) {
      // Handle the error appropriately
      print("Error creating pet: $error");
      throw Exception('Failed to create pet: $error');
    }
  }
}
