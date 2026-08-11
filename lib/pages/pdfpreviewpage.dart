import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';

class PdfPreviewPage extends StatefulWidget {
  final String projectName;

  const PdfPreviewPage({super.key, required this.projectName});

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  Map<String, dynamic> projectData = {};

  @override
  void initState() {
    super.initState();
    loadProject();
  }

  pw.Widget buildInfoFieldpdf({required String value, required String label}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(color: PdfColors.grey, fontSize: 12),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: const pw.TextStyle(
            color: PdfColors.black,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    final settings = projectData["settings"] ?? {};

    final weeks = projectData["weeks"] ?? [];

    List<pw.Widget> reportWidgets = [];

    bool _hasValue(dynamic value) {
      return value != null && value.toString().trim().isNotEmpty;
    }

    // 2. Build the list of valid field widgets
    List<pw.Widget> _buildFields() {
      final fields = <pw.Widget>[];

      if (_hasValue(settings["studentName"])) {
        fields.add(
          pw.SizedBox(
            width: 225,
            child: buildInfoFieldpdf(
              value: settings["studentName"].toString(),
              label: settings["studentNameLabel"] ?? "Student Name",
            ),
          ),
        );
      }

      if (_hasValue(settings["companyName"])) {
        fields.add(
          pw.SizedBox(
            width: 225,
            child: buildInfoFieldpdf(
              value: settings["companyName"].toString(),
              label: settings["companyNameLabel"] ?? "Company Name",
            ),
          ),
        );
      }

      if (_hasValue(settings["internshipRole"])) {
        fields.add(
          pw.SizedBox(
            width: 225,
            child: buildInfoFieldpdf(
              value: settings["internshipRole"].toString(),
              label: settings["internshipRoleLabel"] ?? "Role",
            ),
          ),
        );
      }

      if (_hasValue(settings["startDate"]) && _hasValue(settings["endDate"])) {
        fields.add(
          pw.SizedBox(
            width: 225,
            child: buildInfoFieldpdf(
              value: "${settings["startDate"]} - ${settings["endDate"]}",
              label: settings["durationLabel"] ?? "Duration",
            ),
          ),
        );
      }

      if (_hasValue(settings["collegeName"])) {
        fields.add(
          pw.SizedBox(
            width: 225,
            child: buildInfoFieldpdf(
              value: settings["collegeName"].toString(),
              label: settings["collegeNameLabel"] ?? "College Name",
            ),
          ),
        );
      }

      if (_hasValue(settings["guideName"])) {
        fields.add(
          pw.SizedBox(
            width: 225,
            child: buildInfoFieldpdf(
              value: settings["guideName"].toString(),
              label: settings["guideNameLabel"] ?? "Guide Name",
            ),
          ),
        );
      }

      return fields;
    }

    final infoFields = _buildFields();

    for (final week in weeks) {
      reportWidgets.add(
        pw.Text(
          (week["title"] ?? "").toString().isNotEmpty
              ? "Week ${week["week"]} - ${week["title"]}"
              : "Week ${week["week"]}",
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.blue,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );

      reportWidgets.add(pw.SizedBox(height: 10));

      final entries = week["entries"] ?? [];

      for (final entry in entries) {
        final imageWidgets = await loadPdfImages(entry);

        // We'll add the container in the next step.
        reportWidgets.add(
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Day ${entry["day"]} | ${getWeekDay(entry["date"] ?? "")} , ${entry["date"] ?? "-"}",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),

                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.blue50,
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Text(
                      "${entry["hours"] ?? "-"} hrs",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue800,
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 4),
              if ((entry["title"] ?? []).toString().trim().isNotEmpty) ...[
                pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: "Task: ",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      pw.TextSpan(
                        text: entry["title"] ?? "-",
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
              pw.SizedBox(height: 2),

              pw.Row(
                children: [
                  pw.Text(
                    "Working Duration: ",
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  pw.Row(
                    children: [
                      pw.Text(
                        formatTime12Hour(entry["from"]),
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        " - ",
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        formatTime12Hour(entry["to"]),
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 4),

              if ((entry["challenges"] ?? []).toString().trim().isNotEmpty) ...[
                pw.Text(
                  "Challenges",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                pw.SizedBox(height: 2),

                pw.Text(
                  (entry["challenges"] ?? "").toString().isEmpty
                      ? "-"
                      : entry["challenges"],
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
              pw.SizedBox(height: 2),

              if ((entry["description"] ?? [])
                  .toString()
                  .trim()
                  .isNotEmpty) ...[
                pw.Text(
                  "Description",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                pw.SizedBox(height: 2),

                pw.Text(
                  (entry["description"] ?? "").toString().isEmpty
                      ? "-"
                      : entry["description"],
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],

              pw.SizedBox(height: 4),

              if ((entry["links"] ?? []).isNotEmpty) ...[
                pw.Text(
                  "Links",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                pw.SizedBox(height: 2),

                ...(entry["links"] as List).map((link) {
                  return pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "${link["title"]} - ",
                        style: const pw.TextStyle(fontSize: 12),
                      ),

                      pw.UrlLink(
                        destination: link["url"],
                        child: pw.Text(
                          link["url"],
                          style: const pw.TextStyle(
                            color: PdfColors.blue,
                            decoration: pw.TextDecoration.underline,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],

              pw.SizedBox(height: 4),

              if (imageWidgets.isNotEmpty)
                pw.Text(
                  "Screenshots",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

              if (imageWidgets.isNotEmpty) pw.SizedBox(height: 5),

              if (imageWidgets.isNotEmpty)
                pw.Wrap(spacing: 8, runSpacing: 8, children: imageWidgets),
            ],
          ),
        );

        reportWidgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Divider(color: PdfColors.grey400, thickness: 0.8),
          ),
        );
      }

      reportWidgets.add(
        pw.Text(
          "Week Summary :",
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.blue,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      );

      reportWidgets.add(
        pw.Text(
          week["weekSummary"] ?? "",
          style: const pw.TextStyle(fontSize: 12),
        ),
      );

      reportWidgets.add(pw.SizedBox(height: 20));
      reportWidgets.add(pw.Divider());
      reportWidgets.add(pw.SizedBox(height: 20));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        build: (context) => [
          pw.Center(
            child: pw.RichText(
              text: pw.TextSpan(
                children: [
                  pw.TextSpan(
                    text: "Daily Work Report ",
                    style: pw.TextStyle(
                      color: PdfColors.blue,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  pw.TextSpan(
                    text:
                        settings["title"] != null &&
                            settings["title"]!.isNotEmpty
                        ? "- ${settings["title"]}"
                        : "",
                    style: pw.TextStyle(
                      color: PdfColors.blue,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          pw.SizedBox(height: 20),
            pw.Divider(thickness: 2, color: PdfColors.blue),
            pw.SizedBox(height: 20),

          // Inside your main widget tree:
          if (infoFields.isNotEmpty) ...[
            pw.Wrap(spacing: 10, runSpacing: 10, children: infoFields),
            pw.SizedBox(height: 20),
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 20),
          ],

          pw.Text(
            "Daily Report",
            style: pw.TextStyle(
              color: PdfColors.blue,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 20),

          ...reportWidgets,
        ],
      ),
    );

    await savePdf(pdf);
  }

  String getWeekDay(String dateString) {
    try {
      final parts = dateString.split('-');

      final date = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );

      const days = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

      return days[date.weekday - 1];
    } catch (e) {
      return '';
    }
  }

  Future<void> savePdf(pw.Document pdf) async {
    final docs = await getApplicationDocumentsDirectory();

    final exportDir = Directory('${docs.path}/DailyReportGenerator/exports');

    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final file = File('${exportDir.path}/${widget.projectName}_Report.pdf');

    await file.writeAsBytes(await pdf.save());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF90CAF9),
          content: Text(
            'PDF Saved:\n${file.path}',
            style: TextStyle(color: Color.fromARGB(255, 20, 20, 20)),
          ),
        ),
      );
    }
  }

  Future<File> getProjectFile() async {
    final docs = await getApplicationDocumentsDirectory();

    return File(
      '${docs.path}/DailyReportGenerator/projects/${widget.projectName.replaceAll(" ", "_")}.json',
    );
  }

  Future<void> loadProject() async {
    final file = await getProjectFile();

    if (!await file.exists()) return;

    projectData = jsonDecode(await file.readAsString());

    setState(() {});
  }

  Future<List<pw.Widget>> loadPdfImages(dynamic entry) async {
  final List<pw.Widget> images = [];

  try {
    final rawImages = entry["images"];

    if (rawImages == null || rawImages is! List) {
      return images;
    }

    for (final imagePath in rawImages) {
      try {
        if (imagePath == null) continue;

        final path = imagePath.toString().trim();

        if (path.isEmpty) continue;

        final file = File(path);

        if (!await file.exists()) {
          debugPrint("PDF IMAGE NOT FOUND: $path");
          continue;
        }

        final bytes = await file.readAsBytes();

        if (bytes.isEmpty) {
          debugPrint("PDF IMAGE EMPTY: $path");
          continue;
        }

        debugPrint(
          "PDF IMAGE LOADED: $path (${bytes.length} bytes)",
        );

        images.add(
          pw.Image(
            pw.MemoryImage(bytes),
            width: 180,
            height: 180,
            fit: pw.BoxFit.contain,
          ),
        );
      } catch (e, stackTrace) {
        debugPrint("ERROR LOADING PDF IMAGE: $imagePath");
        debugPrint("ERROR: $e");
        debugPrint("$stackTrace");

        // Skip this broken image instead of crashing the whole PDF.
        continue;
      }
    }
  } catch (e, stackTrace) {
    debugPrint("ERROR IN loadPdfImages(): $e");
    debugPrint("$stackTrace");
  }

  return images;
}

  String formatTime12Hour(String time) {
    if (time.isEmpty) return "";

    final parts = time.split(":");

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    final period = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:${minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    final settings = projectData["settings"] ?? {};

    final weeks = projectData["weeks"] ?? [];

    // 1. Helper function to check valid strings
    bool _hasValue(dynamic value) {
      return value != null && value.toString().trim().isNotEmpty;
    }

    // 2. Build the list of valid field widgets
    List<Widget> _buildFields() {
      final fields = <Widget>[];

      if (_hasValue(settings["studentName"])) {
        fields.add(
          SizedBox(
            width: 450,
            child: buildInfoField(
              value: settings["studentName"].toString(),
              label: settings["studentNameLabel"] ?? "Student Name",
            ),
          ),
        );
      }

      if (_hasValue(settings["companyName"])) {
        fields.add(
          SizedBox(
            width: 450,
            child: buildInfoField(
              value: settings["companyName"].toString(),
              label: settings["companyNameLabel"] ?? "Company Name",
            ),
          ),
        );
      }

      if (_hasValue(settings["internshipRole"])) {
        fields.add(
          SizedBox(
            width: 450,
            child: buildInfoField(
              value: settings["internshipRole"].toString(),
              label: settings["internshipRoleLabel"] ?? "Role",
            ),
          ),
        );
      }

      if (_hasValue(settings["startDate"]) && _hasValue(settings["endDate"])) {
        fields.add(
          SizedBox(
            width: 450,
            child: buildInfoField(
              value: "${settings["startDate"]} - ${settings["endDate"]}",
              label: settings["durationLabel"] ?? "Duration",
            ),
          ),
        );
      }

      if (_hasValue(settings["collegeName"])) {
        fields.add(
          SizedBox(
            width: 450,
            child: buildInfoField(
              value: settings["collegeName"].toString(),
              label: settings["collegeNameLabel"] ?? "College Name",
            ),
          ),
        );
      }

      if (_hasValue(settings["guideName"])) {
        fields.add(
          SizedBox(
            width: 450,
            child: buildInfoField(
              value: settings["guideName"].toString(),
              label: settings["guideNameLabel"] ?? "Guide Name",
            ),
          ),
        );
      }

      return fields;
    }

    final infoFields = _buildFields();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 12, 12),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disables default back button
        leading: Tooltip(
          message: 'Go back to Project Details', // Your custom hover text hint
          decoration: BoxDecoration(
            color: Color(0xFF90CAF9),
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 20, 20, 20),
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF90CAF9),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF90CAF9), // Your custom blue color
        ),
        title: const Text(
          "PDF Preview",
          style: TextStyle(color: Color(0xFF90CAF9)),
        ),
      ),

      body: projectData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(60),

              child: Container(
                color: Colors.white,

                child: Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(50, 30, 50, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // header
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Daily Work Report ",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 42,
                                ),
                              ),
                              TextSpan(
                                text:
                                    settings["title"] != null &&
                                        settings["title"]!.isNotEmpty
                                    ? "- ${settings["title"]}"
                                    : "",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 42,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Divider(thickness: 2, color: Colors.blue),

                      const SizedBox(height: 20),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     SizedBox(
                      //       width: 500,
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           if ((settings["studentName"] ?? "")
                      //               .toString()
                      //               .trim()
                      //               .isNotEmpty)
                      //             Text(
                      //               settings["studentNameLabel"] ??
                      //                   "Student Name",
                      //               style: const TextStyle(
                      //                 color: Colors.grey,
                      //                 fontSize: 22,
                      //               ),
                      //             ),

                      //           const SizedBox(height: 4),

                      //           Text(
                      //             settings["studentName"] ?? "",
                      //             style: const TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 23,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),

                      //     const SizedBox(width: 40),

                      //     if ((settings["companyName"] ?? "")
                      //         .toString()
                      //         .trim()
                      //         .isNotEmpty)
                      //       Column(
                      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             settings["companyNameLabel"] ??
                      //                 "Company Name",
                      //             style: const TextStyle(
                      //               color: Colors.grey,
                      //               fontSize: 22,
                      //             ),
                      //           ),

                      //           const SizedBox(height: 4),

                      //           Text(
                      //             settings["companyName"] ?? "",
                      //             style: const TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 23,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //   ],
                      // ),

                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     SizedBox(
                      //       width: 500,
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           if ((settings["internshipRole"] ?? "")
                      //               .toString()
                      //               .trim()
                      //               .isNotEmpty)
                      //             Text(
                      //               settings["internshipRoleLabel"] ??
                      //                   "Internship Program ",
                      //               style: const TextStyle(
                      //                 color: Colors.grey,
                      //                 fontSize: 22,
                      //               ),
                      //             ),

                      //           const SizedBox(height: 4),

                      //           Text(
                      //             settings["internshipRole"] ?? "",
                      //             style: const TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 23,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),

                      //     const SizedBox(width: 40),

                      //     if ((settings["startDate"] ?? "")
                      //             .toString()
                      //             .trim()
                      //             .isNotEmpty &&
                      //         (settings["endDate"] ?? "")
                      //             .toString()
                      //             .trim()
                      //             .isNotEmpty)
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             settings["durationLabel"] ?? "Duration",
                      //             style: const TextStyle(
                      //               color: Colors.grey,
                      //               fontSize: 22,
                      //             ),
                      //           ),

                      //           const SizedBox(height: 4),

                      //           RichText(
                      //             text: TextSpan(
                      //               children: [
                      //                 TextSpan(
                      //                   text: settings["startDate"] ?? "",
                      //                   style: const TextStyle(
                      //                     color: Colors.black,
                      //                     fontSize: 23,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //                 TextSpan(
                      //                   text: " - ",
                      //                   style: const TextStyle(
                      //                     color: Colors.black,
                      //                     fontSize: 23,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //                 TextSpan(
                      //                   text: settings["endDate"] ?? "",
                      //                   style: const TextStyle(
                      //                     color: Colors.black,
                      //                     fontSize: 23,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //   ],
                      // ),

                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     SizedBox(
                      //       width: 500,
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           if ((settings["collegeName"] ?? "")
                      //               .toString()
                      //               .trim()
                      //               .isNotEmpty)
                      //             Text(
                      //               settings["collegeNameLabel"] ??
                      //                   "College Name",
                      //               style: const TextStyle(
                      //                 color: Colors.grey,
                      //                 fontSize: 22,
                      //               ),
                      //             ),

                      //           const SizedBox(height: 4),

                      //           Text(
                      //             settings["collegeName"] ?? "",
                      //             style: const TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 23,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     const SizedBox(width: 40),
                      //     if ((settings["guideName"] ?? "")
                      //         .toString()
                      //         .trim()
                      //         .isNotEmpty)
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             settings["guideNameLabel"] ?? "Guide Name",
                      //             style: const TextStyle(
                      //               color: Colors.grey,
                      //               fontSize: 22,
                      //             ),
                      //           ),

                      //           const SizedBox(height: 4),

                      //           Text(
                      //             settings["guideName"] ?? "",
                      //             style: const TextStyle(
                      //               color: Colors.black,
                      //               fontSize: 23,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //   ],
                      // ),

                      // Inside your main widget tree:
                      if (infoFields.isNotEmpty) ...[
                        Wrap(spacing: 10, runSpacing: 10, children: infoFields),
                        const SizedBox(height: 20),
                        const Divider(thickness: 2),
                        const SizedBox(height: 20),
                      ],

                      Text(
                        "Daily Report",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...weeks.map<Widget>((week) {
                        final entries = week["entries"] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (week["title"] ?? "").toString().isNotEmpty
                                  ? "Week ${week["week"]}  -  Task: ${week["title"]}"
                                  : "Week ${week["week"]}",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 15),

                            ...entries.map<Widget>((entry) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Day ${entry["day"]} | ${getWeekDay(entry["date"] ?? "")} , ${entry["date"] ?? "-"}",
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          //color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          "${entry["hours"] ?? "-"} hrs",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 4),
                                  if ((entry["title"] ?? []).isNotEmpty) ...[
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Task : ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 22,
                                            ),
                                          ),
                                          TextSpan(
                                            text: entry["title"] ?? "-",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Text(
                                        "Working Duration: ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            formatTime12Hour(entry["from"]),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                            ),
                                          ),
                                          Text(
                                            " - ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                            ),
                                          ),
                                          Text(
                                            formatTime12Hour(entry["to"]),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8),

                                  if ((entry["challenges"] ?? [])
                                      .isNotEmpty) ...[
                                    Text(
                                      "Challenges : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),

                                    SizedBox(height: 2),

                                    Text(
                                      (entry["challenges"] ?? "")
                                              .toString()
                                              .isEmpty
                                          ? "-"
                                          : entry["challenges"],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 12),

                                  if ((entry["description"] ?? [])
                                      .isNotEmpty) ...[
                                    Text(
                                      "Description : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),

                                    SizedBox(height: 2),
                                    Text(
                                      (entry["description"] ?? "")
                                              .toString()
                                              .isEmpty
                                          ? "-"
                                          : entry["description"],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],

                                  SizedBox(height: 2),
                                  if ((entry["images"] ?? []).isNotEmpty) ...[
                                    const SizedBox(height: 15),

                                    const Text(
                                      "Screenshots",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: (entry["images"] as List)
                                          .map<Widget>((path) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                File(path),
                                                width: 320,
                                                height: 320,
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ],

                                  if ((entry["links"] ?? []).isNotEmpty) ...[
                                    const SizedBox(height: 15),

                                    Text(
                                      "Links",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    ...(entry["links"] as List).map((link) {
                                      final urlString = link["url"] ?? "";
                                      return InkWell(
                                        onTap: () async {
                                          final Uri uri = Uri.parse(urlString);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(
                                              uri,
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                link["title"] ?? urlString,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                "  - ",
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                link["url"] ?? urlString,
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ],

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 0.8,
                                    ),
                                  ),
                                ],
                              );
                            }),

                            Text(
                              "Week Summary : ",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              week["weekSummary"] ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                            ),

                            SizedBox(height: 20),

                            Divider(),

                            SizedBox(height: 20),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await generatePdf();
        },

        backgroundColor: Color(0xFF90CAF9),

        icon: const Icon(Icons.save, color: Color.fromARGB(255, 20, 20, 20)),

        label: const Text(
          "Save PDF",
          style: TextStyle(color: Color.fromARGB(255, 20, 20, 20)),
        ),
      ),
    );
  }

  Widget buildInfoField({required String value, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
