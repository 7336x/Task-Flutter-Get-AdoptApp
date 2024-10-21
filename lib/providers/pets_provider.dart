import 'package:adopt_app/models/pet.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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

  Future<Pet> createPet(Pet pet) async {
    late Pet newPet;

    try {
      FormData data = FormData.fromMap({
        'name': pet.name,
        'age': pet.age,
        'gender': pet.gender,
        // Add other properties as needed
      });

      Response response = await _dio.post(
        "https://coded-pets-api-crud.eapi.joincoded.com/pets",
        data: data,
      );

      newPet = Pet.fromJson(response.data);
    } on DioError catch (error) {
      print("Error adding pet: $error");
      throw Exception('Failed to add pet: ${error.message}');
    }

    return newPet;
  }

  // Function to update a pet
  Future<Pet> updatePet(Pet pet) async {
    try {
      FormData data = FormData.fromMap({
        'name': pet.name,
        'age': pet.age,
        'gender': pet.gender,
        // Add other properties as needed
      });

      Response response = await _dio.put(
        "https://coded-pets-api-crud.eapi.joincoded.com/pets/${pet.id}",
        data: data,
      );

      return Pet.fromJson(response.data);
    } on DioError catch (error) {
      print("Error updating pet: $error");
      throw Exception('Failed to update pet: ${error.message}');
    }
  }

  Future<Pet> getPetById(String id) async {
    try {
      Response response = await _dio
          .get("https://coded-pets-api-crud.eapi.joincoded.com/pets/$id");
      return Pet.fromJson(response.data);
    } on DioError catch (error) {
      print("Error fetching pet: $error");
      throw Exception('Failed to fetch pet: ${error.message}');
    }
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

  Future<List<Pet>> getPets() async {
    pets = await DioClient().getPets();
    return pets;
  }

  Future<List<Pet>> getPetsWithNotify() async {
    pets = await DioClient().getPets();
    notifyListeners();
    return pets;
  }

  Future<void> createPet(Pet toAdd) async {
    try {
      Pet newPet = await DioClient().createPet(toAdd);
      pets.add(newPet);
      notifyListeners();
    } catch (error) {
      print("Error creating pet: $error");
      throw Exception('Failed to create pet: $error');
    }
  }

  Future<Pet> getPetById(String id) async {
    return await DioClient().getPetById(id);
  }

  // New updatePet method
  Future<void> updatePet(Pet pet) async {
    try {
      // Call the service to update the pet
      Pet updatedPet = await DioClient().updatePet(pet);

      // Find the index of the pet to replace
      int index = pets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        pets[index] = updatedPet; // Replace the old pet with the updated one
      }

      // Notify listeners to update the UI
      notifyListeners();
    } catch (error) {
      print("Error updating pet: $error");
      throw Exception('Failed to update pet: $error');
    }
  }
}
