import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': 'Getting Started',
      'icon': Icons.rocket_launch,
      'questions': [
        {
          'question': 'How do I create my first project?',
          'answer':
              'Go to the Projects section from the sidebar and click the "New Project" button. Enter your project name, then save the project. Your new project will appear in the Projects list.'
        },
        {
          'question': 'How do I create a weekly report?',
          'answer':
              'Open your project and Click on Plus button below to add Week. Select the week you want to work on and add your daily entries. Once your entries are complete, you can generate a PDF report from the top right button.'
        },
        {
          'question': 'How do I add daily entries?',
          'answer':
              'Open a project and select the week u want to add entry for. Click on plus Button Below to add day and fillup necessary information, for that entry and save the entry.'
        },
        {
          'question': 'How do I generate my PDF?',
          'answer':
              'Open the project you want to export and select the PDF/Generate Report option. The app will create a PDF using your project information, weekly reports, daily entries, and images. (Note if pdf is large and container many images then it will need some time to generate pdf)'
        },
      ],
    },
    {
      'title': 'Reports & PDF',
      'icon': Icons.description,
      'questions': [
        {
          'question': 'How do I edit a report?',
          'answer':
              'Open the project containing the report and select the required week or day. You can edit the information and save your changes before generating the PDF again.'
        },
        {
          'question': 'How do I add images?',
          'answer':
              'Open the daily entry where you want to add an image and use the Add Image option. Select an image from your computer and save the entry.'
        },
        {
          'question': 'Why did my PDF move content to another page?',
          'answer':
              'PDFs automatically arrange content according to the available space on the page. Large images, long text, or many entries can cause some content to continue on the next page. This does not normally mean your data is lost.'
        },
        {
          'question': 'Where are my generated PDFs?',
          'answer':
              'Generated PDFs are saved to the location selected by the application. If you cannot find a PDF, try generating the report again and check the save location shown by the app.'
        },
      ],
    },
    {
      'title': 'Data',
      'icon': Icons.storage,
      'questions': [
        {
          'question': 'Where are my projects stored?',
          'answer':
              'Your projects are stored locally on your device. Daily Report does not require an online account for normal project management.'
        },
        {
          'question': 'How do I backup my projects?',
          'answer':
              'Copy your project json file from project folder to your system somewhere safe.'
        },
        {
          'question': 'How do I restore a backup?',
          'answer':
              'if you want to restore your projects then paste the project json file back again in projects folder, app will automatically read data and show it in app.'
        },
        {
          'question': 'What happens if I uninstall the app?',
          'answer':
              'Depending on your operating system and how the application data is stored, uninstalling the app may remove locally stored project data. Always create a backup before uninstalling or moving the application.'
        },
      ],
    },
    {
      'title': 'Troubleshooting',
      'icon': Icons.bug_report,
      'questions': [
        {
          'question': "The app isn't saving my data",
          'answer':
              'Make sure the application has permission to write to its storage location. Try saving again and restart the application. If the problem continues, report the iusse in contact support.'
        },
        {
          'question': "My images aren't showing",
          'answer':
              'Make sure the original image still exists and can be accessed by the application. If the image was moved or deleted from your computer, it may no longer be available to the report.'
        },
        {
          'question': 'PDF generation is not working',
          'answer':
              'Try saving your project first and generate the PDF again. Also Note if your pdf is large and also contain many images then app will need some time to regenrate all data and build pdf so wait for a while. If the problem continues, check that your project contains valid data and that the application can access the required files.'
        },
        {
          'question': 'My project disappeared',
          'answer':
              'First restart the application and check the Projects section again. If the project is still missing, check whether you recently changed or deleted application data. If you have a backup, use Restore to recover your project.'
        },
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredQuestions(
      List<Map<String, dynamic>> questions) {
    if (_searchQuery.isEmpty) {
      return questions;
    }

    return questions.where((item) {
      final question = item['question'].toString().toLowerCase();
      final answer = item['answer'].toString().toLowerCase();

      return question.contains(_searchQuery.toLowerCase()) ||
          answer.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 12, 12),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildSearchBar(),
                  const SizedBox(height: 32),

                  ..._faqCategories.map((category) {
                    final questions = _getFilteredQuestions(
                      List<Map<String, dynamic>>.from(
                        category['questions'],
                      ),
                    );

                    if (questions.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return _buildCategory(
                      category['title'],
                      questions,
                      category['icon'],
                    );
                  }),

                  // const SizedBox(height: 20),
                  // _buildSupportSection(),

                  const SizedBox(height: 40),

                  Center(
                    child: Text(
                      'Daily Report • Help & Support',
                      style: TextStyle(
                        color: Color(0xFF90CAF9).withOpacity(0.3),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Help & Support',
          style: TextStyle(
            color: Color(0xFF90CAF9),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Need help with Daily Report? Find answers or contact us.',
          style: TextStyle(
            color: Color(0xFF90CAF9).withOpacity(0.55),
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // SEARCH
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121820),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Color(0xFF90CAF9),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(
          color: Color(0xFF90CAF9),
        ),
        decoration: InputDecoration(
          hintText: 'Search for a question...',
          hintStyle: TextStyle(
            color: Color(0xFF90CAF9).withOpacity(0.35),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF90CAF9),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF90CAF9),
                  ),
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CATEGORY
  // ------------------------------------------------------------

  Widget _buildCategory(
    String title,
    List<Map<String, dynamic>> questions,
    IconData? icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
            left: 4,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: const Color(0xFF90CAF9),
                  size: 20,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF90CAF9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ),

        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 20, 20, 20),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Color(0xFF90CAF9).withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              for (int i = 0; i < questions.length; i++) ...[
                _buildFAQItem(
                  questions[i]['question'],
                  questions[i]['answer'],
                ),

                if (i != questions.length - 1)
                  Divider(
                    height: 1,
                    color: Color(0xFF90CAF9).withOpacity(0.1),
                  ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }

  // ------------------------------------------------------------
  // FAQ ACCORDION
  // ------------------------------------------------------------

  Widget _buildFAQItem(
    String question,
    String answer,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),
        iconColor: const Color(0xFF90CAF9),
        collapsedIconColor: Color(0xFF90CAF9),

        title: Text(
          question,
          style: const TextStyle(
            color: Color(0xFF90CAF9),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),

        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(
                color: Color(0xFF90CAF9).withOpacity(0.58),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SUPPORT SECTION
  // ------------------------------------------------------------

  // Widget _buildSupportSection() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: const Color.fromARGB(255, 20, 20, 20),
  //       borderRadius: BorderRadius.circular(18),
  //       border: Border.all(
  //         color: const Color(0xFF90CAF9).withOpacity(0.15),
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         const Text(
  //           'Still need help?',
  //           style: TextStyle(
  //             color: Color(0xFF90CAF9),
  //             fontSize: 21,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),

  //         const SizedBox(height: 7),

  //         Text(
  //           'We would love to hear from you.',
  //           style: TextStyle(
  //             color: Color(0xFF90CAF9).withOpacity(0.5),
  //             fontSize: 14,
  //           ),
  //         ),

  //         const SizedBox(height: 22),

  //         Wrap(
  //           alignment: WrapAlignment.center,
  //           spacing: 12,
  //           runSpacing: 12,
  //           children: [
  //             _supportButton(
  //               icon: Icons.bug_report_outlined,
  //               label: 'Report a Bug',
  //               onPressed: _showBugReportDialog,
  //             ),

  //             _supportButton(
  //               icon: Icons.mail_outline,
  //               label: 'Contact Support',
  //               onPressed: _contactSupport,
  //             ),

  //             _supportButton(
  //               icon: Icons.lightbulb_outline,
  //               label: 'Send Feedback',
  //               onPressed: _showFeedbackDialog,
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ------------------------------------------------------------
  // SUPPORT BUTTON
  // ------------------------------------------------------------

  // Widget _supportButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onPressed,
  // }) {
  //   return OutlinedButton.icon(
  //     onPressed: onPressed,
  //     icon: Icon(
  //       icon,
  //       size: 18,
  //     ),
  //     label: Text(label),
  //     style: OutlinedButton.styleFrom(
  //       foregroundColor: Color(0xFF90CAF9),
  //       side: BorderSide(
  //         color: Color(0xFF90CAF9).withOpacity(0.12),
  //       ),
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 18,
  //         vertical: 14,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //   );
  // }

// Helper method to launch mail URLs safely
// Future<void> _sendEmail({
//   required String subject,
//   required String body,
// }) async {
//   final Uri emailUri = Uri(
//     scheme: 'mailto',
//     path: 'koltesohambigwork01@gmail.com',
//     queryParameters: {
//       'subject': subject,
//       'body': body,
//     },
//   );

//   try {
//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(
//         emailUri,
//         mode: LaunchMode.externalApplication, // Ensures it opens the native mail client
//       );
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open email application.')),
//         );
//       }
//     }
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error launching email client: $e')),
//       );
//     }
//   }
// }

  // ------------------------------------------------------------
  // BUG REPORT
  // ------------------------------------------------------------

  // void _showBugReportDialog() {
  //   final whatController = TextEditingController();
  //   final stepsController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return _dialogContainer(
  //         title: '🐛 Report a Bug',
  //         children: [
  //           _dialogLabel('What went wrong?'),

  //           _textField(
  //             controller: whatController,
  //             hint: 'Describe the problem...',
  //             maxLines: 4,
  //           ),

  //           const SizedBox(height: 18),

  //           _dialogLabel(
  //             'What were you doing when it happened?',
  //           ),

  //           _textField(
  //             controller: stepsController,
  //             hint: 'Tell us what you were doing...',
  //             maxLines: 4,
  //           ),

  //           const SizedBox(height: 18),

  //           _appVersion(),

  //           const SizedBox(height: 20),

  //           OutlinedButton.icon(
  //             onPressed: () {
  //               // Screenshot attachment can be added later.
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                   content: Text(
  //                     'Screenshot attachment will be added soon.',
  //                   ),
  //                 ),
  //               );
  //             },
  //             icon: const Icon(Icons.image_outlined),
  //             label: const Text('Attach Screenshot'),
  //           ),

  //           const SizedBox(height: 20),

  //           _primaryButton(
  //             label: 'Send Report',
  //             onPressed: () {
  //               _sendBugReport(
  //                 whatController.text,
  //                 stepsController.text,
  //               );

  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // ------------------------------------------------------------
  // FEEDBACK
  // ------------------------------------------------------------

  // void _showFeedbackDialog() {
  //   final feedbackController = TextEditingController();
  //   final featureController = TextEditingController();

  //   int rating = 0;

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setDialogState) {
  //           return _dialogContainer(
  //             title: '💡 Give Feedback',
  //             children: [
  //               _dialogLabel(
  //                 'How would you rate Daily Report?',
  //               ),

  //               const SizedBox(height: 8),

  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: List.generate(
  //                   5,
  //                   (index) {
  //                     final selected = index < rating;

  //                     return IconButton(
  //                       onPressed: () {
  //                         setDialogState(() {
  //                           rating = index + 1;
  //                         });
  //                       },
  //                       icon: Icon(
  //                         selected
  //                             ? Icons.star
  //                             : Icons.star_border,
  //                         size: 32,
  //                         color: selected
  //                             ? const Color(0xFF00D9FF)
  //                             : Colors.white30,
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),

  //               const SizedBox(height: 15),

  //               _dialogLabel(
  //                 'What can we improve?',
  //               ),

  //               _textField(
  //                 controller: feedbackController,
  //                 hint: 'Tell us what you think...',
  //                 maxLines: 4,
  //               ),

  //               const SizedBox(height: 18),

  //               _dialogLabel(
  //                 'What feature would you like to see?',
  //               ),

  //               _textField(
  //                 controller: featureController,
  //                 hint: 'Your feature idea...',
  //                 maxLines: 3,
  //               ),

  //               const SizedBox(height: 22),

  //               _primaryButton(
  //                 label: 'Send Feedback',
  //                 onPressed: () {
  //                   _sendFeedback(
  //                     rating,
  //                     feedbackController.text,
  //                     featureController.text,
  //                   );

  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // ------------------------------------------------------------
  // CONTACT SUPPORT
  // ------------------------------------------------------------


// Contact Support Button
// Future<void> _contactSupport() async {
//   await _sendEmail(
//     subject: 'Daily Report Support Request',
//     body: 'Hello Support Team,\n\nI need help with: ',
//   );
// }

// // Bug Report Dialog Action
// Future<void> _sendBugReport(String problem, String steps) async {
//   final String body = '''
// What went wrong:
// $problem

// What were you doing:
// $steps

// App Version:
// v1.0.0
// ''';

//   await _sendEmail(
//     subject: 'Daily Report Bug Report',
//     body: body,
//   );
// }

// // Feedback Dialog Action
// Future<void> _sendFeedback(int rating, String feedback, String feature) async {
//   final String body = '''
// Rating:
// $rating / 5

// What can we improve:
// $feedback

// Feature request:
// $feature
// ''';

//   await _sendEmail(
//     subject: 'Daily Report Feedback',
//     body: body,
//   );
// }
//   // ------------------------------------------------------------
//   // DIALOG HELPERS
//   // ------------------------------------------------------------

//   Widget _dialogContainer({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return AlertDialog(
//       backgroundColor: const Color(0xFF121820),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           color: Color(0xFF90CAF9),
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       content: SizedBox(
//         width: 520,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: children,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _dialogLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: Color(0xFF90CAF9),
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _textField({
//     required TextEditingController controller,
//     required String hint,
//     int maxLines = 3,
//   }) {
//     return TextField(
//       controller: controller,
//       maxLines: maxLines,
//       style: const TextStyle(
//         color: Color(0xFF90CAF9),
//       ),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(
//           color: Color(0xFF90CAF9).withOpacity(0.3),
//         ),
//         filled: true,
//         fillColor: const Color(0xFF0B0F14),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(
//             color: Color(0xFF90CAF9),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _appVersion() {
//     return Row(
//       children: [
//         Text(
//           'App Version',
//           style: TextStyle(
//             color: Color(0xFF90CAF9).withOpacity(0.45),
//           ),
//         ),
//         const Spacer(),
//         const Text(
//           'v1.0.0',
//           style: TextStyle(
//             color: Color(0xFF90CAF9),
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _primaryButton({
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF90CAF9),
//           foregroundColor: Colors.black,
//           padding: const EdgeInsets.symmetric(
//             vertical: 15,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: Text(
//           label,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
}