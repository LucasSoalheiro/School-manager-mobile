import 'package:flutter/material.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/di/service_locator.dart';

class ServerConfigDialog extends StatefulWidget {
  const ServerConfigDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ServerConfigDialog(),
    );
  }

  @override
  State<ServerConfigDialog> createState() => _ServerConfigDialogState();
}

class _ServerConfigDialogState extends State<ServerConfigDialog> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: ServiceLocator.sessionStorage.getBaseUrl(),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _save(String url) async {
    await ServiceLocator.sessionStorage.saveBaseUrl(url.trim());
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('URL da API alterada para: ${url.trim()}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.settings_ethernet_rounded, color: Colors.blue),
          SizedBox(width: 10),
          Text('Configurar Servidor API'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Altere o endereço do servidor Fastify para conectar no emulador, dispositivo físico ou rede local:',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL Base',
                hintText: 'http://10.0.2.2:3000',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Atalhos rápidos:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ActionChip(
                  label: const Text('Android (10.0.2.2)'),
                  onPressed: () => _urlController.text = 'http://10.0.2.2:3000',
                ),
                ActionChip(
                  label: const Text('Localhost (3000)'),
                  onPressed: () => _urlController.text = 'http://localhost:3000',
                ),
                ActionChip(
                  label: const Text('Padrão do Sistema'),
                  onPressed: () => _urlController.text = ApiConstants.defaultBaseUrl,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _save(_urlController.text),
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
