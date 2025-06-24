import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class MainContent extends StatefulWidget {
  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _allFiles = [];
  List<Map<String, String>> _filteredFiles = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final data = await rootBundle.loadString('assets/files.txt');
      final lines = data.split('\n');
      _allFiles = lines.map((line) {
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
        _filteredFiles = _allFiles;
      });
    } catch (e) {
      print('Błąd wczytywania pliku: $e');
    }
  }

  void _onSearchPressed() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredFiles = _allFiles.where((file) {
        final name = file['nazwa']?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Wyszukaj plik...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.blue),
                  onPressed: _onSearchPressed,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          Expanded(
            child: _filteredFiles.isEmpty
                ? Center(child: Text('Brak wyników'))
                : ListView.builder(
                    itemCount: _filteredFiles.length,
                    itemBuilder: (context, index) {
                      final file = _filteredFiles[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(file['nazwa'] ?? 'Brak nazwy'),
                          subtitle: Text(
                              'Autor: ${file['autor']}, Rozmiar: ${file['rozmiar']}, Dodano: ${file['dodano']}'),
                          leading: Icon(Icons.insert_drive_file, color: Colors.blue),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
