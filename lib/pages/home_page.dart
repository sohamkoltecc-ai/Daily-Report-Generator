import 'package:dailyreport/pages/about_page.dart';
import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'project_page.dart';
import 'settings_page.dart';
import 'calendar_page.dart';
import 'help_support_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const DashBoardPage(),
    const ProjectsPage(),
    const CalendarPage(),
    const SettingsPage(),
    const HelpSupportPage(),
    const AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 20, 20, 20), // FIX: Moved inside decoration
              boxShadow: [
                BoxShadow(color: Color(0xFF90CAF9), blurRadius: 5, offset: const Offset(0, 1),),
              ],
            ),

            child: Column(
              children: [
                const SizedBox(height: 30),

                const Text(
                  "Daily Report",
                  style: TextStyle(color: Color(0xFF90CAF9), fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                Expanded(
                  flex: 9,
                  child: Column(
                    children: [
                      menuButton(
                        icon: Icons.dashboard,
                        title: "Dashboard",
                        index: 0,
                      ),

                      menuButton(
                        icon: Icons.folder,
                        title: "Projects",
                        index: 1,
                      ),
                      
                      menuButton(
                        icon: Icons.calendar_month_rounded,
                        title: "Calendar",
                        index: 2,
                      ),

                      menuButton(
                        icon: Icons.settings,
                        title: "Settings",
                        index: 3,
                      ),

                      menuButton(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        index: 4,
                      ),

                      menuButton(
                        icon: Icons.info_outline,
                        title: "About",
                        index: 5,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Divider(
                        color: const Color(0xFF90CAF9),
                        height: 3,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 20, color: Color(0xFF90CAF9)),
                          const SizedBox(width: 6),
                          Text(
                            " Version 1.26.8",
                            style: const TextStyle(color: Color(0xFF90CAF9), fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }

  Widget menuButton({
    required IconData icon,
    required String title,
    required int index,
  }) {
    bool selected = selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: Color(0xFF90CAF9),),

      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF90CAF9)),
      ),

      tileColor: selected ? Colors.white24 : Colors.transparent,

      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
