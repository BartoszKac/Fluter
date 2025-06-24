import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:math';

class ShareContent extends StatefulWidget {
  @override
  _ShareContentState createState() => _ShareContentState();
}

class _ShareContentState extends State<ShareContent> {
  String? fileName;
  String? generatedLink;
  String description = '';
  
  // Typ udostępnienia (publiczne, prywatne, ograniczone)
  String sharingType = 'publiczne';

  // Slider wartości
  double availableDownloads = 10;
  double maxUsers = 5;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.name.isNotEmpty) {
      setState(() {
        fileName = result.files.single.name;
        generatedLink = null;
      });
    }
  }

  void generateLink() {
    if (fileName != null) {
      final random = Random();
      final code = List.generate(8, (_) => random.nextInt(36).toRadixString(36)).join();
      setState(() {
        generatedLink = 'https://example.com/download/$code/${Uri.encodeComponent(fileName!)}';
      });
    }
  }

  Widget buildCheckbox(String title, String value) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            sharingType = value;
          });
        },
        child: Row(
          children: [
            Checkbox(
              value: sharingType == value,
              onChanged: (checked) {
                if (checked == true) {
                  setState(() {
                    sharingType = value;
                  });
                }
              },
            ),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Center(
            child: ElevatedButton.icon(
              icon: Icon(Icons.upload_file),
              label: Text("Wybierz plik z komputera"),
              onPressed: pickFile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20),

          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Dodaj opis pliku...',
            ),
            onChanged: (val) {
              setState(() {
                description = val;
              });
            },
          ),

          SizedBox(height: 20),

          // Przycisk generowania linku
          ElevatedButton(
            onPressed: (fileName != null) ? generateLink : null,
            child: Text("Wygeneruj link"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    buildCheckbox('Publiczne', 'publiczne'),
                    buildCheckbox('Prywatne', 'prywatne'),
                    buildCheckbox('Ograniczone', 'ograniczone'),
                  ],
                ),
              ),

              SizedBox(width: 16),

              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dostępne pobrania: ${availableDownloads.toInt()}'),
                    Slider(
                      min: 1,
                      max: 100,
                      divisions: 99,
                      value: availableDownloads,
                      label: availableDownloads.toInt().toString(),
                      onChanged: (val) {
                        setState(() {
                          availableDownloads = val;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Text('Ilość osób: ${maxUsers.toInt()}'),
                    Slider(
                      min: 1,
                      max: 50,
                      divisions: 49,
                      value: maxUsers,
                      label: maxUsers.toInt().toString(),
                      onChanged: (val) {
                        setState(() {
                          maxUsers = val;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),

          if (generatedLink != null) ...[
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: SelectableText(
                generatedLink!,
                style: TextStyle(fontSize: 16, color: Colors.blue[800]),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
