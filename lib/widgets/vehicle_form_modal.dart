import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../utils/email_utils.dart';


// Reusable vehicle form modal for add/edit
void showVehicleFormModal({
  required BuildContext context,
  required List<String> brands,
  Vehicle? vehicle,
  required Function(Vehicle newVehicle) onSave,
  Function()? onDelete,
}) {
  final nameController = TextEditingController(text: vehicle?.name ?? '');
  final modelController = TextEditingController(text: vehicle?.model ?? '');
  final yearController = TextEditingController(
    text: vehicle?.year.toString() ?? '',
  );
  final priceController = TextEditingController(
    text: vehicle?.price.toString() ?? '',
  );
  final imageController = TextEditingController(text: vehicle?.imageUrl ?? '');
  final descriptionController = TextEditingController(
    text: vehicle?.description ?? '',
  );
  String selectedBrand =
      vehicle?.brand ?? (brands.isNotEmpty ? brands.first : '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      Text(
                        vehicle == null
                            ? 'Agregar vehículo'
                            : 'Editar vehículo',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () {
                          final newVehicle = Vehicle(
                            id:
                                vehicle?.id ??
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                            name: nameController.text.trim(),
                            brand: selectedBrand,
                            model: modelController.text.trim(),
                            year: int.tryParse(yearController.text) ?? 0,
                            imageUrl: imageController.text.trim(),
                            description: descriptionController.text.trim(),
                            price: double.tryParse(priceController.text) ?? 0.0,
                          );
                          onSave(newVehicle);
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          value: selectedBrand.isNotEmpty
                              ? selectedBrand
                              : null,
                          decoration: const InputDecoration(labelText: 'Marca'),
                          items: brands.map((brand) {
                            return DropdownMenuItem(
                              value: brand,
                              child: Text(brand),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) selectedBrand = value;
                          },
                        ),
                        TextField(
                          controller: modelController,
                          decoration: const InputDecoration(
                            labelText: 'Modelo',
                          ),
                        ),
                        TextField(
                          controller: yearController,
                          decoration: const InputDecoration(labelText: 'Año'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            labelText: 'Precio',
                            prefixText: 'Q',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                          ),
                        ),
                        StatefulBuilder(
                          builder: (context, setModalState) {
                            return Column(
                              children: [
                                TextField(
                                  controller: imageController,
                                  decoration: const InputDecoration(
                                    labelText: 'URL Imagen',
                                  ),
                                  onChanged: (_) => setModalState(() {}),
                                ),
                                const SizedBox(height: 8),
                                if (imageController.text.isNotEmpty)
                                  Image.network(
                                    imageController.text,
                                    height: 180,
                                    errorBuilder: (_, __, ___) =>
                                        const Text('URL inválida'),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (vehicle != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => sendVehicleQuoteEmail(vehicle),
                        child: const Text('Solicitar cotización'),
                      ),
                    ),
                  ),
                if (onDelete != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('¿Eliminar vehículo?'),
                              content: const Text(
                                'Esta acción no se puede deshacer.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    'Eliminar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            Navigator.pop(context);
                            onDelete.call();
                          }
                        },
                        child: const Text(
                          'Eliminar vehículo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}
