import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vehicle.dart';
import '../widgets/vehicle_form_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Vehicle>> vehiclesByBrand = {
      'Honda': [
        Vehicle(
          id: '1',
          name: 'Civic',
          brand: 'Honda',
          model: 'EX',
          year: 2025,
          imageUrl:
              'https://www.honda.mx/web/img/cars/models/civic/2025/colors/blanco.png',
          description: 'Sedán compacto, eficiente y confiable.',
          price: 25000.0,
        ),
        Vehicle(
          id: '2',
          name: 'Accord',
          brand: 'Honda',
          model: 'Touring',
          year: 2023,
          imageUrl:
              'https://di-uploads-pod16.dealerinspire.com/pattypeckhonda/uploads/2023/02/2023-Accord-Research-Hero-1200x500-1.png',
          description: 'Sedán mediano de lujo y gran desempeño.',
          price: 32000.0,
        ),
        Vehicle(
          id: '3',
          name: 'CR-V',
          brand: 'Honda',
          model: 'EX-L',
          year: 2023,
          imageUrl:
              'https://d31sro4iz4ob5n.cloudfront.net/upload/car/cr-v-2023/color/lhd-ex-l-platinum-white-pearl/1.png?v=2135197424',
          description: 'SUV familiar espacioso y moderno.',
          price: 35000.0,
        ),
      ],
      'Toyota': [
        Vehicle(
          id: '4',
          name: 'Corolla',
          brand: 'Toyota',
          model: 'CS2-24',
          year: 2024,
          imageUrl:
              'https://www.toyota.com.gt/hubfs/Corolla%20CS2-24%20negro.png',
          description: 'Sedán compacto ideal para ciudad.',
          price: 22000.0,
        ),
        Vehicle(
          id: '5',
          name: 'Hilux',
          brand: 'Toyota',
          model: 'SR5',
          year: 2023,
          imageUrl:
              'https://www.toyota.com.gt/img/hilux/hilux-color-super-blanco.png',
          description: 'Pickup resistente para trabajo y aventura.',
          price: 40000.0,
        ),
        Vehicle(
          id: '6',
          name: 'Fortuner',
          brand: 'Toyota',
          model: 'Limited',
          year: 2023,
          imageUrl:
              'https://wallpapers.com/images/hd/toyota-fortuner-s-u-v-profile-view-zwfjtkxldiqnubyv.jpg',
          description: 'SUV todo terreno con gran capacidad.',
          price: 48000.0,
        ),
      ],
      'Tesla': [
        Vehicle(
          id: '7',
          name: 'Model 3',
          brand: 'Tesla',
          model: 'Standard',
          year: 2022,
          imageUrl:
              'https://www.pngplay.com/wp-content/uploads/13/Tesla-Model-3-Transparent-Background.png',
          description: 'Sedán eléctrico innovador y eficiente.',
          price: 42000.0,
        ),
        Vehicle(
          id: '8',
          name: 'Model Y',
          brand: 'Tesla',
          model: 'Juniper',
          year: 2025,
          imageUrl:
              'https://d198k1c0ztf4q8.cloudfront.net/eyJidWNrZXQiOiJldnJlbnRpbmdhc3NldHMiLCJrZXkiOiIyMDI1XC8wMlwvMjFcLzkyMTMwNjkzNF9UZXNsYU1vZGVsWUp1bmlwZXIyMDI1LnBuZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6MTIwMCwiZml0IjoiY29udGFpbiJ9fX0=',
          description: 'SUV eléctrico espacioso y versátil.',
          price: 55000.0,
        ),
        Vehicle(
          id: '9',
          name: 'Model S',
          brand: 'Tesla',
          model: 'Plaid',
          year: 2020,
          imageUrl:
              'https://www.motortrend.com/uploads/bg-index/2020-tesla-models.png',
          description: 'El sedán eléctrico más rápido y lujoso.',
          price: 90000.0,
        ),
      ],
    };

    final List<String> brands = vehiclesByBrand.keys.toList();
    String selectedBrand = 'All';

    return StatefulBuilder(
      builder: (context, setState) {
        final displayList = selectedBrand == 'All'
            ? vehiclesByBrand.entries.expand((e) => e.value).toList()
            : vehiclesByBrand[selectedBrand] ?? [];

        final selectedIndex = ['All', ...brands].indexOf(selectedBrand);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Catalogo de Vehículos'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: ToggleButtons(
                    isSelected: List.generate(
                      brands.length + 1,
                      (index) => index == selectedIndex,
                    ),
                    onPressed: (index) {
                      final newBrand = ['All', ...brands][index];
                      setState(() => selectedBrand = newBrand);
                    },
                    borderRadius: BorderRadius.circular(12),
                    selectedColor: Colors.white,
                    color: Colors.black87,
                    fillColor: Theme.of(context).primaryColor,
                    constraints: const BoxConstraints(
                      minHeight: 40,
                      minWidth: 100,
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    children: ['All', ...brands]
                        .map(
                          (b) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(b),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final v = displayList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: Image.network(
                          v.imageUrl,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text('${v.brand} ${v.name}'),
                        subtitle: Text(
                          '${v.model} - ${v.year}\n${v.description}',
                        ),
                        onTap: () {
                          showVehicleFormModal(
                            context: context,
                            brands: brands,
                            vehicle: v,
                            onSave: (updated) {
                              setState(() {
                                final idx = vehiclesByBrand[v.brand]!
                                    .indexWhere((veh) => veh.id == v.id);
                                if (idx != -1)
                                  vehiclesByBrand[v.brand]![idx] = updated;
                              });
                            },
                            onDelete: () {
                              setState(() {
                                vehiclesByBrand[v.brand]!.removeWhere(
                                  (veh) => veh.id == v.id,
                                );
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showVehicleFormModal(
                context: context,
                brands: brands,
                onSave: (newVehicle) {
                  setState(() {
                    if (vehiclesByBrand.containsKey(newVehicle.brand)) {
                      vehiclesByBrand[newVehicle.brand]!.add(newVehicle);
                    } else {
                      vehiclesByBrand[newVehicle.brand] = [newVehicle];
                      brands.add(newVehicle.brand);
                    }
                  });
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

