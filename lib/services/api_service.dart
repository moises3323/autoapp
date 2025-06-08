import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class ApiService {
  static const String baseUrl = 'https://autoapp-backend-production.up.railway.app/api';

  static Future<List<Vehicle>> fetchVehicles() async {
    final url = Uri.parse('$baseUrl/auto');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['payload']['data'];

      return data.map((item) => Vehicle.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener vehículos');
    }
  }

  static Future<Vehicle> createVehicle(Vehicle vehicle) async {
    final url = Uri.parse('$baseUrl/auto');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final dynamic payload = jsonResponse['payload'];
      final Map<String, dynamic> data =
          payload is Map<String, dynamic> && payload.containsKey('data')
              ? payload['data']
              : payload;
      return Vehicle.fromJson(data);
    } else {
      throw Exception('Error al crear vehículo');
    }
  }

  static Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    final url = Uri.parse('$baseUrl/auto');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(vehicle.toJson(includeId: true)),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final dynamic payload = jsonResponse['payload'];
      final Map<String, dynamic> data =
          payload is Map<String, dynamic> && payload.containsKey('data')
              ? payload['data']
              : payload;
      return Vehicle.fromJson(data);
    } else {
      throw Exception('Error al actualizar vehículo');
    }
  }

  static Future<void> deleteVehicle(int id) async {
    final url = Uri.parse('$baseUrl/auto/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar vehículo');
    }
  }
}