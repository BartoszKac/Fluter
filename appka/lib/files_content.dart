import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class FilesContent extends StatefulWidget {
  @override
  _FilesContentState createState() => _FilesContentState();
}

class _FilesContentState extends State<FilesContent> {
  List<Map<String, String>> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final data = await rootBundle.loadString('assets/files.txt');
      final lines = data.split('\n');
      final parsedFiles = lines.map((line) {
        final parts = line.split(';');
        final Map<String, String> fileData = {};
        for (var part in parts) {
          final kv = part.split('=');
          if (kv.length == 2) {
            fileData[kv[0].trim()] = kv[1].trim();
          }
        }
        return fileData;
      }).toList();

      setState(() {
        _files = parsedFiles;
      });
    } catch (e) {
      print('Błąd wczytywania pliku: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _files.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: _files.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 kolumny
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1, // kwadrat
              ),
              itemBuilder: (context, index) {
                final file = _files[index];
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.insert_drive_file, color: Colors.blue, size: 32),
                      SizedBox(height: 8),
                      Text(
                        file['nazwa'] ?? 'Brak nazwy',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text('Autor: ${file['autor'] ?? ''}', style: TextStyle(fontSize: 12)),
                      Text('Rozmiar: ${file['rozmiar'] ?? ''}', style: TextStyle(fontSize: 12)),
                      Text('Dodano: ${file['dodano'] ?? ''}', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
