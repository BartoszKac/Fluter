import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class DriveContent extends StatefulWidget {
  @override
  _DriveContentState createState() => _DriveContentState();
}

class _DriveContentState extends State<DriveContent> {
  List<String> fileList = [];

  // Ścieżka katalogu użytkownika (home) - Windows i Linux/macOS
  String getUserHomePath() {
    if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'] ?? '';
    } else {
      return Platform.environment['HOME'] ?? '';
    }
  }

  // Pobierz plik lokalny w katalogu użytkownika (np. Documents/appka_files/files.txt)
  Future<File> _getLocalFile() async {
    final homeDir = getUserHomePath();
    if (homeDir.isEmpty) {
      throw Exception('Nie znaleziono katalogu użytkownika!');
    }
    final dirPath = '$homeDir\\Documents\\appka_files';
    final directory = Directory(dirPath);
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }
    return File('$dirPath/files.txt');
  }

  // Wczytaj zawartość pliku do listy
  Future<void> _readFile() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final lines = await file.readAsLines();
        setState(() {
          fileList = lines;
        });
      } else {
        setState(() {
          fileList = [];
        });
      }
    } catch (e) {
      print('Błąd odczytu pliku: $e');
      setState(() {
        fileList = [];
      });
    }
  }

  // Dopisz linię do pliku
  Future<void> _appendToFile(String line) async {
    try {
      final file = await _getLocalFile();
      await file.writeAsString(line + '\n', mode: FileMode.append);
      await _readFile(); // odśwież listę po dopisaniu
    } catch (e) {
      print('Błąd zapisu pliku: $e');
    }
  }

  // Obsługa wyboru pliku
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.name.isNotEmpty) {
        final fileName = result.files.single.name;
        final now = DateTime.now();
        final line = "nazwa=$fileName; dodano=${now.toIso8601String()}";
        await _appendToFile(line);
      }
    } catch (e) {
      print('Błąd podczas wybierania pliku: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _readFile(); // wczytaj dane przy starcie
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.upload_file),
            label: Text('Dodaj plik'),
            onPressed: _pickFile,
          ),
          SizedBox(height: 20),
          Expanded(
            child: fileList.isEmpty
                ? Center(child: Text('Brak dodanych plików'))
                : ListView.builder(
                    itemCount: fileList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(fileList[index]),
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
