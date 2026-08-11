import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:io';

// import 'package:file_selector/file_selector.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // ------------------------------------------------------------
  // APP INFORMATION
  // ------------------------------------------------------------

  static const String appVersion = "1.26.8";
  static const String buildNumber = "1";

  static const String developerName = "SohamArts";
  static const String supportEmail = "dailyreport.support@gmail.com";
  // support@sohamarts.com
  Future<void> _launchEmail(BuildContext context) async {
    // ------------------------------------------------------------
    // EMAIL FORM CONTROLLERS
    // ------------------------------------------------------------

    final TextEditingController emailController = TextEditingController();

    final TextEditingController subjectController = TextEditingController(
      text: 'Daily Report App Feedback',
    );

    final TextEditingController messageController = TextEditingController(
      text: 'Hello SohamArts Support Team,\n\n',
    );

    // String? selectedImagePath;

    // ------------------------------------------------------------
    // SHOW DIALOG
    // ------------------------------------------------------------

    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return Dialog(
              backgroundColor: const Color.fromARGB(255, 20, 20, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 650,
                  maxHeight: 720,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // HEADER
                      // ==================================================
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF90CAF9).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF90CAF9),
                              size: 25,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Support',
                                  style: TextStyle(
                                    color: Color(0xFF90CAF9),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 4),

                                Text(
                                  'Send feedback or get help with Daily Report.',
                                  style: TextStyle(
                                    color: Color(0xFF90CAF9),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF90CAF9),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // ==================================================
                      // YOUR EMAIL
                      // ==================================================
                      const Text(
                        'Your Email',
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 14,
                        ),
                        decoration: _emailInputDecoration(
                          hint: 'Enter your email address',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // TO
                      // ==================================================
                      const Text(
                        'To',
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 15, 15, 15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF90CAF9).withOpacity(0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lock_outline_rounded,
                              color: Color(0xFF90CAF9),
                              size: 18,
                            ),

                            const SizedBox(width: 10),

                            const Expanded(
                              child: Text(
                                supportEmail,
                                style: TextStyle(
                                  color: Color(0xFF90CAF9),
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            Text(
                              'Support',
                              style: TextStyle(
                                color: const Color(0xFF90CAF9).withOpacity(0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // SUBJECT
                      // ==================================================
                      const Text(
                        'Subject',
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: subjectController,
                        style: const TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 14,
                        ),
                        decoration: _emailInputDecoration(
                          hint: 'Enter subject',
                          icon: Icons.title_rounded,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // MESSAGE
                      // ==================================================
                      const Text(
                        'Message',
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 7),

                      TextField(
                        controller: messageController,
                        minLines: 6,
                        maxLines: 8,
                        style: const TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Write your message...',
                          hintStyle: TextStyle(
                            color: const Color(0xFF90CAF9).withOpacity(0.35),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 15, 15, 15),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF90CAF9).withOpacity(0.12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFF90CAF9).withOpacity(0.12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF90CAF9),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ==================================================
                      // IMAGE
                      // ==================================================
                      // Row(
                      //   children: [
                      //     OutlinedButton.icon(
                      //       onPressed: () async {
                      //         const XTypeGroup imageTypeGroup = XTypeGroup(
                      //           label: 'Images',
                      //           extensions: <String>[
                      //             'jpg',
                      //             'jpeg',
                      //             'png',
                      //             'gif',
                      //             'bmp',
                      //             'webp',
                      //           ],
                      //         );

                      //         try {
                      //           final XFile? selectedFile = await openFile(
                      //             acceptedTypeGroups: <XTypeGroup>[
                      //               imageTypeGroup,
                      //             ],
                      //             confirmButtonText: 'Select',
                      //           );

                      //           if (selectedFile == null) {
                      //             return;
                      //           }

                      //           setDialogState(() {
                      //             selectedImagePath = selectedFile.path;
                      //           });
                      //         } catch (e) {
                      //           debugPrint('Image picker error: $e');

                      //           if (context.mounted) {
                      //             ScaffoldMessenger.of(context).showSnackBar(
                      //               const SnackBar(
                      //                 content: Text(
                      //                   'Unable to select the image.',
                      //                 ),
                      //               ),
                      //             );
                      //           }
                      //         }
                      //       },
                      //       icon: const Icon(Icons.image_outlined, size: 18),
                      //       label: const Text('Add Image'),
                      //       style: OutlinedButton.styleFrom(
                      //         foregroundColor: const Color(0xFF90CAF9),
                      //         side: BorderSide(
                      //           color: const Color(
                      //             0xFF90CAF9,
                      //           ).withOpacity(0.25),
                      //         ),
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //       ),
                      //     ),

                      //     const SizedBox(width: 12),

                      //     if (selectedImagePath != null)
                      //       Expanded(
                      //         child: Row(
                      //           children: [
                      //             const Icon(
                      //               Icons.attach_file_rounded,
                      //               color: Color(0xFF90CAF9),
                      //               size: 17,
                      //             ),

                      //             const SizedBox(width: 6),

                      //             Expanded(
                      //               child: Text(
                      //                 File(
                      //                   selectedImagePath!,
                      //                 ).path.split(Platform.pathSeparator).last,
                      //                 overflow: TextOverflow.ellipsis,
                      //                 style: TextStyle(
                      //                   color: const Color(
                      //                     0xFF90CAF9,
                      //                   ).withOpacity(0.65),
                      //                   fontSize: 12,
                      //                 ),
                      //               ),
                      //             ),

                      //             IconButton(
                      //               tooltip: 'Remove image',
                      //               onPressed: () {
                      //                 setDialogState(() {
                      //                   selectedImagePath = null;
                      //                 });
                      //               },
                      //               icon: const Icon(
                      //                 Icons.close_rounded,
                      //                 color: Color(0xFF90CAF9),
                      //                 size: 18,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //   ],
                      // ),

                      // const SizedBox(height: 8),

                      // if (selectedImagePath != null)
                      //   Text(
                      //     'Image selected. You can attach it in Gmail after the composer opens.',
                      //     style: TextStyle(
                      //       color: const Color(0xFF90CAF9).withOpacity(0.45),
                      //       fontSize: 11,
                      //     ),
                      //   ),

                      // const SizedBox(height: 25),

                      // ==================================================
                      // BUTTONS
                      // ==================================================
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, false);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF90CAF9),
                                  side: BorderSide(
                                    color: const Color(
                                      0xFF90CAF9,
                                    ).withOpacity(0.20),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Validate email
                                  if (emailController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Color(0xFF90CAF9),
                                        content: Text(
                                          'Please enter your email address.',
                                          style: TextStyle(color: Color.fromARGB(255, 20, 20, 20)),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // Validate subject
                                  if (subjectController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Color(0xFF90CAF9),
                                        content: Text(
                                          'Please enter a subject.',
                                          style: TextStyle(color: Color.fromARGB(255, 20, 20, 20)),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  // Validate message
                                  if (messageController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Color(0xFF90CAF9),
                                        content: Text(
                                          'Please enter a message.',
                                          style: TextStyle(color: Color.fromARGB(255, 20, 20, 20)),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.pop(dialogContext, true);
                                },
                                icon: const Icon(Icons.send_rounded, size: 18),
                                label: const Text('Open Email'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF90CAF9),
                                  foregroundColor: const Color.fromARGB(
                                    255,
                                    20,
                                    20,
                                    20,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // ------------------------------------------------------------
    // IF USER CANCELLED
    // ------------------------------------------------------------

    if (result != true) {
      emailController.dispose();
      subjectController.dispose();
      messageController.dispose();
      return;
    }

    // ------------------------------------------------------------
    // GET FORM DATA
    // ------------------------------------------------------------

    // final String userEmail = emailController.text.trim();

    final String subject = subjectController.text.trim();

    final String message = messageController.text.trim();

    // ------------------------------------------------------------
    // GMAIL COMPOSER
    // ------------------------------------------------------------

    final Uri gmailUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm'
      '&fs=1'
      '&to=${Uri.encodeComponent(supportEmail)}'
      '&su=${Uri.encodeComponent(subject)}'
      '&body=${Uri.encodeComponent(message)}',
    );

    try {
      await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not open Gmail: $e');
    }

    // ------------------------------------------------------------
    // CLEAN UP
    // ------------------------------------------------------------

    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
  }

  InputDecoration _emailInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: const Color(0xFF90CAF9).withOpacity(0.35)),
      prefixIcon: Icon(icon, color: const Color(0xFF90CAF9), size: 20),
      filled: true,
      fillColor: const Color.fromARGB(255, 15, 15, 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: const Color(0xFF90CAF9).withOpacity(0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: const Color(0xFF90CAF9).withOpacity(0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF90CAF9)),
      ),
    );
  }

  Future<void> _showPolicyDialog(
    BuildContext context,
    String title,
    String assetPath,
  ) async {
    String content;

    try {
      content = await rootBundle.loadString(assetPath);
    } catch (e) {
      content = "Unable to load this document.";
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(255, 20, 20, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800, maxHeight: 600),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: Color(0xFF90CAF9),
                        size: 26,
                      ),

                      const SizedBox(width: 12),

                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: const Color(0xFF90CAF9).withOpacity(0.25),
                ),

                // Document
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: SelectableText(
                      content,
                      style: const TextStyle(
                        color: Color(0xFF90CAF9),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),

                Divider(
                  height: 1,
                  color: const Color(0xFF90CAF9).withOpacity(0.25),
                ),

                // Close button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF90CAF9),
                        foregroundColor: const Color.fromARGB(255, 20, 20, 20),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 12, 12),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // HEADER
                // ==================================================
                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App icon
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: const Color(0xFF90CAF9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF90CAF9).withOpacity(0.25),
                            blurRadius: 18,
                            spreadRadius: 1,
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.description_rounded,
                        color: Color.fromARGB(255, 12, 12, 12),
                        size: 42,
                      ),
                    ),

                    const SizedBox(width: 22),

                    // Title
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Report",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF90CAF9),
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Create. Organize. Report.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF90CAF9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // ==================================================
                // ABOUT
                // ==================================================
                _sectionCard(
                  title: "About Daily Report",
                  icon: Icons.info_outline_rounded,

                  child: const Text(
                    "Daily Report is a simple desktop productivity "
                    "application designed to make daily reporting easier.\n\n"
                    "Create projects, record your daily work, organize "
                    "your reports, manage your schedule, and generate "
                    "professional reports without unnecessary complexity.",
                    style: TextStyle(
                      color: Color(0xFF90CAF9),
                      fontSize: 15,
                      height: 1.7,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // FEATURES
                // ==================================================
                _sectionCard(
                  title: "Features",
                  icon: Icons.auto_awesome_outlined,

                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children: const [
                      _FeatureChip(
                        icon: Icons.folder_outlined,
                        text: "Project management",
                      ),

                      _FeatureChip(
                        icon: Icons.edit_note_rounded,
                        text: "Daily report creation",
                      ),

                      _FeatureChip(
                        icon: Icons.calendar_month_outlined,
                        text: "Calendar",
                      ),

                      _FeatureChip(
                        icon: Icons.article_outlined,
                        text: "Report organization",
                      ),

                      _FeatureChip(
                        icon: Icons.image_outlined,
                        text: "Image support",
                      ),

                      _FeatureChip(
                        icon: Icons.picture_as_pdf_outlined,
                        text: "PDF report generation",
                      ),

                      _FeatureChip(
                        icon: Icons.storage_outlined,
                        text: "Local data storage",
                      ),

                      _FeatureChip(
                        icon: Icons.dashboard_outlined,
                        text: "Simple and focused workspace",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // VERSION
                // ==================================================
                _sectionCard(
                  title: "Version",
                  icon: Icons.new_releases_outlined,

                  child: Column(
                    children: [
                      _infoRow("Version", appVersion),

                      const SizedBox(height: 12),

                      _infoRow("Build", buildNumber),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // DEVELOPER
                // ==================================================
                _sectionCard(
                  title: "Developer",
                  icon: Icons.code_rounded,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Developed by",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        developerName,
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Divider(color: Color(0xFF90CAF9)),

                      const SizedBox(height: 18),

                      Text(
                        "© 2026 $developerName. All rights reserved.",
                        style: const TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LEGAL
                // ==================================================
                _sectionCard(
                  title: "Legal",
                  icon: Icons.gavel_outlined,

                  child: Column(
                    children: [
                      _legalTile(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy Policy",
                        subtitle:
                            "Your privacy matters to us. Read how Daily Report handles your information.",
                        onTap: () {
                          _showPolicyDialog(
                            context,
                            "Privacy Policy",
                            "assets/legal/privacy_policy.txt",
                          );
                        },
                      ),

                      _legalTile(
                        icon: Icons.description_outlined,
                        title: "Terms of Use",
                        subtitle:
                            "Read the rules and conditions for using Daily Report.",
                        onTap: () {
                          _showPolicyDialog(
                            context,
                            "Terms of Use",
                            "assets/legal/terms_of_use.txt",
                          );
                        },
                      ),

                      _legalTile(
                        icon: Icons.copyright_outlined,
                        title: "Software License",
                        subtitle:
                            "View the license governing the use of Daily Report.",
                        onTap: () {
                          _showPolicyDialog(
                            context,
                            "Proprietary License",
                            "assets/legal/proprietary_license.txt",
                          );
                        },
                      ),

                      _legalTile(
                        icon: Icons.extension_outlined,
                        title: "Third-Party Licenses",
                        subtitle:
                            "View licenses and notices for third-party software used by Daily Report.",
                        onTap: () {
                          _showPolicyDialog(
                            context,
                            "Third-Party Licenses",
                            "assets/legal/third_part_license.txt",
                          );
                        },
                      ),

                      _legalTile(
                        icon: Icons.warning_amber_rounded,
                        title: "Disclaimer",
                        subtitle:
                            "Read important information about the use of Daily Report.",
                        onTap: () {
                          _showPolicyDialog(
                            context,
                            "Disclaimer",
                            "assets/legal/disclaimer.txt",
                          );
                        },
                      ),

                      _legalTile(
                        icon: Icons.verified_user_outlined,
                        title: "App License Agreement",
                        subtitle:
                            "Read the app license agreement and conditions for using Daily Report.",
                        onTap: () {
                          _showPolicyDialog(
                            context,
                            "App License Agreement",
                            "assets/legal/license.txt",
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // SUPPORT
                // ==================================================
                _sectionCard(
                  title: "Support",
                  icon: Icons.support_agent_outlined,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Need help with Daily Report?",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Visit Help & Support or contact us using the "
                        "support information below.",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () => _launchEmail(context),

                          icon: const Icon(Icons.email_outlined),

                          label: const Text(supportEmail),

                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF90CAF9),

                            side: BorderSide(
                              color: const Color(0xFF90CAF9).withOpacity(0.5),
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // ==================================================
                // FOOTER
                // ==================================================
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Daily Report",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Create. Organize. Report.",
                        style: TextStyle(
                          color: Color(0xFF90CAF9).withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Version $appVersion",
                        style: TextStyle(
                          color: Color(0xFF90CAF9).withOpacity(0.3),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  // ==============================================================
  // SECTION CARD
  // ==============================================================

  static Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 20, 20),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFF90CAF9).withOpacity(0.18)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF90CAF9), size: 23),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF90CAF9),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }

  // ==============================================================
  // INFO ROW
  // ==============================================================

  static Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFF90CAF9), fontSize: 14),
        ),

        const Spacer(),

        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF90CAF9),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // LEGAL TILE
  // ==============================================================

  static Widget _legalTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 15, 15, 15),

        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: const Color(0xFF90CAF9).withOpacity(0.06)),
      ),

      child: ListTile(
        onTap: onTap,

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

        leading: Icon(icon, color: const Color(0xFF90CAF9), size: 24),

        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF90CAF9),
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: Color(0xFF90CAF9),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xFF90CAF9),
          size: 15,
        ),
      ),
    );
  }
}

// ================================================================
// FEATURE CHIP
// ================================================================

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),

      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 15, 15, 15),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: const Color(0xFF90CAF9).withOpacity(0.18)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF90CAF9), size: 19),

          const SizedBox(width: 8),

          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF90CAF9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
