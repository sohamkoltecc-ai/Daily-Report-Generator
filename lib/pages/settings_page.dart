import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  // --- STATE VARIABLES FOR 12 SYSTEM SETTINGS ---
  // Category 1: User Profile & Identity
  final TextEditingController _usernameController = TextEditingController(
    text: "Developer",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "developer@workspace.local",
  );

  // Category 2: Metrics & Goal Engineering
  int _weeklyHoursGoal = 40;
  bool _enableOvertimeTracking = true;
  bool _autoMarkWeekendAttendance = false;

  // Category 3: Report & File Export Configuration
  String _defaultExportFormat = 'JSON';
  bool _includeEmptyWeeksInReports = false;
  final TextEditingController _exportPathController = TextEditingController();

  // Category 4: System Behaviours & Syncing
  bool _launchOnSystemStartup = false;
  bool _enableDesktopNotifications = true;
  bool _automaticLocalBackup = true;

  @override
  void initState() {
    super.initState();
    _loadApplicationSettings();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _exportPathController.dispose();
    super.dispose();
  }

  // --- PERSISTENCE ENGINE (JSON STORAGE) ---
  Future<File> _getSettingsConfigurationFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final systemFolder = Directory(
      '${directory.path}/DailyReportGenerator/system',
    );
    if (!await systemFolder.exists()) {
      await systemFolder.create(recursive: true);
    }
    return File('${systemFolder.path}/settings.json');
  }

  Future<void> _loadApplicationSettings() async {
    try {
      final file = await _getSettingsConfigurationFile();
      if (!await file.exists()) {
        _exportPathController.text =
            "${(await getApplicationDocumentsDirectory()).path}/DailyReportGenerator/exports";
        return;
      }

      final rawData = jsonDecode(await file.readAsString());
      setState(() {
        _usernameController.text = rawData['username'] ?? "Developer";
        _emailController.text = rawData['email'] ?? "developer@workspace.local";
        _weeklyHoursGoal = rawData['weeklyHoursGoal'] ?? 40;
        _enableOvertimeTracking = rawData['enableOvertimeTracking'] ?? true;
        _autoMarkWeekendAttendance =
            rawData['autoMarkWeekendAttendance'] ?? false;
        _defaultExportFormat = rawData['defaultExportFormat'] ?? 'JSON';
        _includeEmptyWeeksInReports =
            rawData['includeEmptyWeeksInReports'] ?? false;
        _exportPathController.text = rawData['customExportPath'] ?? "";
        _launchOnSystemStartup = rawData['launchOnSystemStartup'] ?? false;
        _enableDesktopNotifications =
            rawData['enableDesktopNotifications'] ?? true;
        _automaticLocalBackup = rawData['automaticLocalBackup'] ?? true;
      });
    } catch (e) {
      debugPrint("Error reading engine settings: $e");
    }
  }

  Future<void> _saveApplicationSettings() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final file = await _getSettingsConfigurationFile();
      final schema = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'weeklyHoursGoal': _weeklyHoursGoal,
        'enableOvertimeTracking': _enableOvertimeTracking,
        'autoMarkWeekendAttendance': _autoMarkWeekendAttendance,
        'defaultExportFormat': _defaultExportFormat,
        'includeEmptyWeeksInReports': _includeEmptyWeeksInReports,
        'customExportPath': _exportPathController.text,
        'launchOnSystemStartup': _launchOnSystemStartup,
        'enableDesktopNotifications': _enableDesktopNotifications,
        'automaticLocalBackup': _automaticLocalBackup,
      };

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(schema),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Configuration updated and saved successfully! 💾',
              style: TextStyle(color: Color.fromARGB(255, 20, 20, 20)),
            ),
            backgroundColor: Color(0xFF90CAF9),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint("Error writing engine settings: $e");
    }
  }

  // --- DESTRUCTIVE SYSTEM MAINTENANCE ACTIONS ---
  Future<void> _purgeStreakMetrics() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(
        '${directory.path}/DailyReportGenerator/system/streak.json',
      );
      if (await file.exists()) {
        await file.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Streak history cleared. Restart dashboard to reflect metrics.',
                style: TextStyle(color: Color.fromARGB(255, 20, 20, 20)),
              ),
              backgroundColor: Color(0xFF90CAF9),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Error purging data payload: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 12, 12),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(
            40.0,
          ), // Matched setup dashboard layout padding
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER DESKTOP ROW SYSTEM
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'System Settings',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF90CAF9), // Exact Master Dashboard Blue
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _saveApplicationSettings,
                      icon: const Icon(
                        Icons.save_rounded,
                        color: Color.fromARGB(255, 20, 20, 20),
                        size: 18,
                      ),
                      label: const Text(
                        'Save Configuration',
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 20, 20),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90CAF9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // 2. CONFIGURATION GRID CARDS MATRIX
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column Layout
                    Expanded(
                      child: Column(
                        children: [
                          _buildSettingsCard(
                            title: "User Profile & Goal Engineering",
                            icon: Icons.person_outline_rounded,
                            children: [
                              _buildTextField(
                                label: "Display Username",
                                controller: _usernameController,
                                icon: Icons.badge_rounded,
                              ),
                              const SizedBox(height: 20),
                              const Divider(
                                color: Color(0xFF90CAF9),
                                height: 32,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Weekly Hours Target",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF90CAF9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownButton<int>(
                                    value: _weeklyHoursGoal,
                                    dropdownColor: Color.fromARGB(
                                      255,
                                      20,
                                      20,
                                      20,
                                    ),
                                    underline: const SizedBox(),
                                    style: const TextStyle(
                                      color: Color(0xFF90CAF9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    items: [20, 30, 40, 50, 60].map((int val) {
                                      return DropdownMenuItem<int>(
                                        value: val,
                                        child: Text("$val Hours"),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(
                                      () => _weeklyHoursGoal = value!,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Right Column Layout
                    Expanded(
                      child: Column(
                        children: [
                          _buildSettingsCard(
                            title: "Report & File Compilation",
                            icon: Icons.folder_open_rounded,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Default Compilation Format",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF90CAF9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: _defaultExportFormat,
                                    dropdownColor: Color.fromARGB(
                                      255,
                                      20,
                                      20,
                                      20,
                                    ),
                                    underline: const SizedBox(),
                                    style: const TextStyle(
                                      color: Color(0xFF90CAF9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    items: ['JSON', 'PDF'].map((String format) {
                                      return DropdownMenuItem<String>(
                                        value: format,
                                        child: Text(format),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(
                                      () => _defaultExportFormat = value!,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xFF90CAF9),
                                height: 32,
                              ),
                              _buildToggleSwitch(
                                title: "Include Empty Activity Iterations",
                                subtitle:
                                    "Export dates even if no contextual tasks exist.",
                                value: _includeEmptyWeeksInReports,
                                onChanged: (val) => setState(
                                  () => _includeEmptyWeeksInReports = val,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                label:
                                    "Compilation Output Root Target Directory",
                                controller: _exportPathController,
                                icon: Icons.computer_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                const SizedBox(height: 25),

                

                
                // 3. ADVANCED ACTIONS ROW (DANGER / MAINTENANCE BLOCK)
                const Text(
                  'Data Engine Maintenance Operations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90CAF9),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 20, 20, 20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF90CAF9),
                      width: 1.5,
                    ), // Soft alert highlight
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF90CAF9),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Purge Cached Productivity Streaks",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB71C1C),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "This triggers an operational system flush of the 'streak.json' file state data. This execution cannot be reverted.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF90CAF9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Prompt warning dialogue modal or perform dynamic routine
                          _purgeStreakMetrics();
                        },
                        icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                        label: const Text(
                          "Reset Analytics",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFD32F2F),
                          side: const BorderSide(color: Color(0xFFEF9A9A)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- CUSTOM UI SYSTEM FACTORIES MAPPED TO SYSTEM THEME ---
  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 20, 20),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF90CAF9),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF90CAF9), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90CAF9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: const Color(0xFF90CAF9),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF90CAF9),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF90CAF9),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF90CAF9), size: 20),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFF90CAF9),
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF90CAF9), width: 1.5),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 20, 20, 20),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      validator: (val) => (val == null || val.trim().isEmpty)
          ? "Field parameter cannot be empty"
          : null,
    );
  }

  Widget _buildToggleSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF90CAF9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF90CAF9)),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color.fromARGB(255, 20, 20, 20),
          activeTrackColor: const Color(0xFF90CAF9),
          inactiveThumbColor: const Color.fromARGB(255, 20, 20, 20),
          inactiveTrackColor: const Color(0xFF90CAF9),
        ),
      ],
    );
  }
}
