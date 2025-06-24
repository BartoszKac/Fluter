import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'side_menu_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> searchResults = [];

  Future<void> _onSearchPressed() async {
    String query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    try {
      final fileContent = await rootBundle.loadString('assets/files.txt');
      final lines = fileContent.split('\n');

      List<Map<String, String>> matches = [];

      for (String line in lines) {
        if (line.trim().isEmpty) continue;

        final entries = line.split(';');
        final data = {
          for (var e in entries)
            e.split('=')[0]: e.split('=').length > 1 ? e.split('=')[1] : ''
        };

        final fileName = data['nazwa']?.toLowerCase() ?? '';

        if (fileName.contains(query)) {
          matches.add(data);
        }
      }

      setState(() {
        searchResults = matches;
      });

      if (matches.isEmpty) {
        print('❌ Brak wyników dla: "$query"');
      }
    } catch (e) {
      print('❗ Błąd wczytywania pliku: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0), // przesunięcie w dół
            child: IconButton(
              icon: Icon(Icons.account_circle, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SideMenuScreen()),
                );
              },
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2196F3),
              Color(0xFF0D47A1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          hintText: 'Wyszukaj...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: _onSearchPressed,
                      child: Icon(Icons.search, color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: searchResults.isEmpty
                      ? Center(
                          child: Text(
                            'Brak wyników',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final result = searchResults[index];
                            return Card(
                              color: Colors.white.withOpacity(0.95),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('📄 ${result['nazwa'] ?? ''}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    SizedBox(height: 4),
                                    Text('✍️ Autor: ${result['autor'] ?? ''}'),
                                    Text('💾 Rozmiar: ${result['rozmiar'] ?? ''}'),
                                    Text('🕓 Dodano: ${result['dodano'] ?? ''}'),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
