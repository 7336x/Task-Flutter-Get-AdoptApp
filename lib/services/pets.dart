import 'package:adopt_app/models/pet.dart';
import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio = Dio();

  // Fetch pets from the API
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

  // Function to update a pet
  Future<Pet> updatePet(Pet pet) async {
    try {
      // Create FormData from the pet data
      FormData data = FormData.fromMap({
        'name': pet.name,
        'age': pet.age,
        'gender': pet.gender,
        // Add other properties as needed
      });

      // Send a PUT request to the specified endpoint with pet.id
      Response response = await _dio.put(
        "https://coded-pets-api-crud.eapi.joincoded.com/pets/${pet.id}", // Inject pet.id in the URL
        data: data, // Pass the FormData
      );

      return Pet.fromJson(response.data); // Return the updated Pet object
    } on DioError catch (error) {
      print("Error updating pet: $error");
      throw Exception(
          'Failed to update pet: ${error.message}'); // Handle the error accordingly
    }
  }
}




/*class DioClient {
  final Dio _dio = Dio();
}*/

