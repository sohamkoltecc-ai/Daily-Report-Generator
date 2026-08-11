import 'package:dailyreport/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../Helper/setting_servive.dart';
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController =
      TextEditingController();

  bool _saving = false;

  Future<void> _saveApplicationSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final username = _usernameController.text.trim();

      await SettingsService.updateSettings({
        'username': username,
        'hasCompletedInitialSetup': true,
      });

      if (!mounted) return;

      // Replace this with your actual DashboardPage.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } catch (e) {
      debugPrint('Error saving initial setup: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your settings. Please try again.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome 👋",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90CAF9),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "What should we call you?",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF90CAF9),
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(
                    color: Color(0xFF90CAF9),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xFF90CAF9),
                    ),
                    hintStyle: const TextStyle(
                      color: Color(0xFF90CAF9),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(
                      255,
                      20,
                      20,
                      20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF90CAF9),
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                        _saving ? null : _saveApplicationSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF90CAF9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(
                                255,
                                20,
                                20,
                                20,
                              ),
                            ),
                          ),
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