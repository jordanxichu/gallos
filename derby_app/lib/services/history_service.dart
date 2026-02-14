import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class HistorialEvento {
  final String tipo;
  final String descripcion;
  final DateTime timestamp;

  const HistorialEvento({
    required this.tipo,
    required this.descripcion,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'tipo': tipo,
        'descripcion': descripcion,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistorialEvento.fromJson(Map<String, dynamic> json) => HistorialEvento(
        tipo: json['tipo'] as String,
        descripcion: json['descripcion'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class HistoryService {
  static const String _fileName = 'derby_history.json';

  Future<List<HistorialEvento>> loadHistory() async {
    final file = await _historyFile();
    if (!await file.exists()) return const [];

    try {
      final raw = await file.readAsString();
      final list = (jsonDecode(raw) as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(HistorialEvento.fromJson)
          .toList();

      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    } catch (_) {
      return const [];
    }
  }

  Future<List<HistorialEvento>> appendEvent({
    required String tipo,
    required String descripcion,
  }) async {
    final history = await loadHistory();
    final updated = [
      HistorialEvento(
        tipo: tipo,
        descripcion: descripcion,
        timestamp: DateTime.now(),
      ),
      ...history,
    ];

    final trimmed = updated.take(500).toList();
    final file = await _historyFile();
    await file.writeAsString(jsonEncode(trimmed.map((e) => e.toJson()).toList()));
    return trimmed;
  }

  Future<File> _historyFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }
}
