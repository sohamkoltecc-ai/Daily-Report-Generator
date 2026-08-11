import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onSelect;

  const SideMenu({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              "Daily Report Generator",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => onSelect(0),
          ),

          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text("Projects"),
            onTap: () => onSelect(1),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () => onSelect(2),
          ),
        ],
      ),
    );
  }
}