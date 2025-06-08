import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/api_service.dart';

class VehicleProvider with ChangeNotifier {
  Map<String, List<Vehicle>> vehiclesByBrand = {};
  List<String> brands = [];
  bool isLoading = false;

  Future<void> fetchVehicles() async {
    isLoading = true;
    notifyListeners();

    try {
      final fetchedVehicles = await ApiService.fetchVehicles();
      final Map<String, List<Vehicle>> grouped = {};

      for (var vehicle in fetchedVehicles) {
        if (!grouped.containsKey(vehicle.brand)) {
          grouped[vehicle.brand] = [];
        }
        grouped[vehicle.brand]!.add(vehicle);
      }

      vehiclesByBrand = grouped;
      brands = grouped.keys.toList();
    } catch (e) {
      debugPrint('Error loading vehicles: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      final newVehicle = await ApiService.createVehicle(vehicle);

      if (vehiclesByBrand.containsKey(newVehicle.brand)) {
        vehiclesByBrand[newVehicle.brand]!.add(newVehicle);
      } else {
        vehiclesByBrand[newVehicle.brand] = [newVehicle];
        brands.add(newVehicle.brand);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding vehicle: $e');
      rethrow;
    }
  }

  Future<void> updateVehicle(Vehicle updated) async {
    try {
      final newVehicle = await ApiService.updateVehicle(updated);

      final list = vehiclesByBrand[newVehicle.brand];
      if (list != null) {
        final index = list.indexWhere((v) => v.id_auto == newVehicle.id_auto);
        if (index != -1) {
          list[index] = newVehicle;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating vehicle: $e');
      rethrow;
    }
  }

  Future<void> deleteVehicle(Vehicle toDelete) async {
    try {
      await ApiService.deleteVehicle(toDelete.id_auto);
      vehiclesByBrand[toDelete.brand]?.removeWhere((v) => v.id_auto == toDelete.id_auto);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting vehicle: $e');
      rethrow;
    }
  }
}
