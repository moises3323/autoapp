import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/vehicle_form_modal.dart';
import '../providers/vehicle_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedBrand = 'All';
  late final FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleProvider>(context, listen: false).fetchVehicles();
    });
  }

  void showCustomToast(String message, {bool success = true}) {
    fToast.init(context);
    fToast.showToast(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: success ? Colors.green.shade600 : Colors.red.shade600,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VehicleProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final vehiclesByBrand = provider.vehiclesByBrand;
        final brands = provider.brands;

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
                            onSave: (updated) async {
                              try {
                                await provider.updateVehicle(updated);
                                showCustomToast("Vehículo actualizado", success: true);
                              } catch (_) {
                                showCustomToast("Error al actualizar vehículo", success: false);
                              }
                            },
                            onDelete: () async {
                              try {
                                await provider.deleteVehicle(v);
                                showCustomToast("Vehículo eliminado", success: true);
                              } catch (_) {
                                showCustomToast("Error al eliminar vehículo", success: false);
                              }
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
                onSave: (newVehicle) async {
                  try {
                    await provider.addVehicle(newVehicle);
                    showCustomToast("Vehículo agregado exitosamente", success: true);
                  } catch (_) {
                    showCustomToast("Error al agregar vehículo", success: false);
                  }
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
