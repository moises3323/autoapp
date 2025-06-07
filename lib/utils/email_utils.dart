import 'package:url_launcher/url_launcher.dart';
import '../models/vehicle.dart';

Future<void> sendVehicleQuoteEmail(Vehicle v) async {
  final subject = Uri.encodeComponent("Cotización de vehículo ${v.brand} ${v.name}");
  final body = Uri.encodeComponent('''
Hola,

Estoy interesado en el siguiente vehículo:

- Marca: ${v.brand}
- Modelo: ${v.model}
- Año: ${v.year}
- Precio: Q${v.price.toStringAsFixed(2)}
- Descripción: ${v.description}
- Imagen: ${v.imageUrl}

¿Podrían brindarme más detalles?

Gracias.
''');

  final emailUri = Uri.parse('mailto:moysantos2013@gmail.com?subject=$subject&body=$body');

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'No se pudo abrir el cliente de correo';
  }
}