import 'package:flutter/material.dart';
import 'main_content.dart';
import 'files_content.dart';
import 'share_content.dart';
import 'drive_content.dart';
import 'account_content.dart';

class SideMenuScreen extends StatefulWidget {
  @override
  _SideMenuScreenState createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  int selectedIndex = 0;

  final List<_MenuItem> menuItems = [
    _MenuItem('Menu główne', Icons.home),
    _MenuItem('Plik', Icons.insert_drive_file),
    _MenuItem('Udostępnij', Icons.share),
    _MenuItem('Dysk główny', Icons.storage),
    _MenuItem('Konto', Icons.people),
  ];

  void onMenuTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    print('Wybrano: ${menuItems[index].title}');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final sidebarWidth = width * 0.3;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: sidebarWidth,
            color: Colors.blue.shade700,
            child: Column(
              children: [
                SizedBox(height: 40),
                ...List.generate(menuItems.length, (index) {
                  final item = menuItems[index];
                  final selected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () => onMenuTap(index),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      decoration: BoxDecoration(
                        color: selected ? Colors.blue.shade300 : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(item.icon, color: selected ? Colors.white : Colors.white70, size: 28),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white70,
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        if (selected)
  Container(
    width: 4,
    height: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      gradient: LinearGradient(
        colors: [
          Color(0xFF0D47A1), 
          Color(0xFF1976D2), 
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  ),

                        ],
                      ),
                    ),
                  );
                }),
                Spacer(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade100,
              child: _getSelectedContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSelectedContent() {
    switch (selectedIndex) {
      case 0:
        return MainContent();
      case 1:
        return FilesContent();
      case 2:
        return ShareContent();
      case 3:
        return DriveContent();
      case 4:
        return AccountContent();
      default:
        return Center(child: Text('Nieznana zakładka'));
    }
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  _MenuItem(this.title, this.icon);
}
