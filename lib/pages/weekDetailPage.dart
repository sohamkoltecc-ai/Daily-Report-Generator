import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../Helper/image_helper.dart';
import '../Helper/image_picker.dart';

import 'package:url_launcher/url_launcher.dart';

class WeekDetailPage extends StatefulWidget {
  final String projectName;
  final int weekNumber;

  const WeekDetailPage({
    super.key,
    required this.projectName,
    required this.weekNumber,
  });

  @override
  State<WeekDetailPage> createState() => _WeekDetailPageState();
}

class _WeekDetailPageState extends State<WeekDetailPage> {
  List<Map<String, dynamic>> entries = [];
  String weekTitle = "";
  String weekSummary = "";

  @override
  void initState() {
    super.initState();
    loadWeekData();
  }

  void showImagePreview(BuildContext context, String path) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(File(path), fit: BoxFit.contain),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File> getProjectFile() async {
    final docs = await getApplicationDocumentsDirectory();

    final projectDir = Directory('${docs.path}/DailyReportGenerator/projects');

    return File(
      '${projectDir.path}/${widget.projectName.replaceAll(" ", "_")}.json',
    );
  }

  Future<void> loadWeekData() async {
    final file = await getProjectFile();

    if (!await file.exists()) return;

    final jsonData = jsonDecode(await file.readAsString());

    final weeks = List<Map<String, dynamic>>.from(jsonData["weeks"] ?? []);

    final week = weeks.firstWhere(
      (e) => e["week"] == widget.weekNumber,
      orElse: () => {},
    );
    weekTitle = week["title"] ?? "";
    weekSummary = week["weekSummary"] ?? "";

    entries = List<Map<String, dynamic>>.from(week["entries"] ?? []);

    setState(() {});
  }

  Future<void> saveWeekData() async {
    final file = await getProjectFile();

    final jsonData = jsonDecode(await file.readAsString());

    List<dynamic> weeks = jsonData["weeks"];

    int index = weeks.indexWhere((e) => e["week"] == widget.weekNumber);
    weeks[index]["title"] = weekTitle;
    weeks[index]["weekSummary"] = weekSummary;
    weeks[index]["entries"] = entries;

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(jsonData),
    );

    print("Saved Week ${widget.weekNumber}");
  }

  Future<Map<String, dynamic>?> addLink({
    Map<String, dynamic>? existingLink,
  }) async {
    final titleController = TextEditingController(
      text: existingLink?["title"] ?? "",
    );

    final urlController = TextEditingController(
      text: existingLink?["url"] ?? "",
    );

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        final isEditing = existingLink != null;

        return AlertDialog(
          title: Center(
            child: Text(
              isEditing ? "Edit Link" : "Add Link",
              style: const TextStyle(
                color: Color(0xFF90CAF9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Color(0xFF90CAF9)),
                decoration: InputDecoration(
                  hintText: "Link Name",
                  hintStyle: const TextStyle(color: Color(0xFF90CAF9)),
                  prefixIcon: const Icon(
                    Icons.storefront_outlined,
                    color: Color(0xFF90CAF9),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 20, 20, 20),

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

              const SizedBox(height: 12),

              TextField(
                controller: urlController,
                style: const TextStyle(color: Color(0xFF90CAF9)),
                decoration: InputDecoration(
                  hintText: "https://example.com",
                  hintStyle: const TextStyle(color: Color(0xFF90CAF9)),
                  prefixIcon: const Icon(
                    Icons.language,
                    color: Color(0xFF90CAF9),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 20, 20, 20),

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
            ],
          ),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Color(0xFF90CAF9)),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();

                    if (title.isEmpty || urlController.text.trim().isEmpty) {
                      return;
                    }

                    String url = urlController.text.trim();

                    if (!url.startsWith("http://") &&
                        !url.startsWith("https://")) {
                      url = "https://$url";
                    }

                    Navigator.pop(context, {"title": title, "url": url});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF90CAF9),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isEditing ? Icons.save : Icons.add,
                        color: const Color.fromARGB(255, 20, 20, 20),
                      ),
                      SizedBox(width: 10),
                      Text(
                        isEditing ? "Save" : "Add",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 20, 20, 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void showEntryDialog({Map<String, dynamic>? entry, int? editIndex}) {
    final dateController = TextEditingController(text: entry?["date"] ?? "");

    final titleController = TextEditingController(text: entry?["title"] ?? "");

    final challengeController = TextEditingController(
      text: entry?["challenges"] ?? "",
    );

    final descriptionController = TextEditingController(
      text: entry?["description"] ?? "",
    );

    double workingHours = entry?["hours"]?.toDouble() ?? 0.0;

    final fromController = TextEditingController(text: entry?["from"] ?? "");

    final toController = TextEditingController(text: entry?["to"] ?? "");

    final hoursController = TextEditingController(
      text: workingHours == 0 ? "" : workingHours.toString(),
    );

    List<String> images = List<String>.from(entry?["images"] ?? []);

    List<Map<String, dynamic>> links = List<Map<String, dynamic>>.from(
      entry?["links"] ?? [],
    );

    void calculateHours(StateSetter dialogSetState) {
      if (fromController.text.isEmpty || toController.text.isEmpty) return;

      final from = fromController.text.split(":");
      final to = toController.text.split(":");

      final fromMinutes = int.parse(from[0]) * 60 + int.parse(from[1]);

      final toMinutes = int.parse(to[0]) * 60 + int.parse(to[1]);

      int diff = toMinutes - fromMinutes;

      if (diff < 0) {
        diff += 24 * 60;
      }

      workingHours = diff / 60;

      dialogSetState(() {
        int hours = workingHours.floor();
        int minutes = ((workingHours - hours) * 60).round();

        hoursController.text = "$hours hr $minutes min";
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return Dialog(
              elevation: 1,
              shadowColor: Color(0xFF90CAF9),
              child: SizedBox(
                width: 700,
                height: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                editIndex == null
                                    ? Icons.note_add
                                    : Icons.edit_note_rounded,
                                color: const Color(0xFF90CAF9),
                                size: 28,
                              ),

                              const SizedBox(width: 12),

                              Text(
                                editIndex == null
                                    ? "Add Day Entry"
                                    : "Edit Entry",
                                style: const TextStyle(
                                  color: Color(0xFF90CAF9),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: dateController,
                          style: const TextStyle(color: Color(0xFF90CAF9)),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Select Date",
                            hintStyle: const TextStyle(
                              color: Color(0xFF90CAF9),
                            ),
                            prefixIcon: const Icon(
                              Icons.calendar_today_rounded,
                              color: Color(0xFF90CAF9),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 20, 20, 20),

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
                                color: Color.fromARGB(255, 20, 20, 20),
                                width: 1.5,
                              ),
                            ),

                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              dateController.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}-"
                                  "${pickedDate.month.toString().padLeft(2, '0')}-"
                                  "${pickedDate.year}";
                            }
                          },
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: fromController,
                                readOnly: true,
                                style: const TextStyle(
                                  color: Color(0xFF90CAF9),
                                ),
                                decoration: InputDecoration(
                                  labelText: "Select Start Time",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF90CAF9),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.access_time,
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
                                      color: Color.fromARGB(255, 20, 20, 20),
                                      width: 1.5,
                                    ),
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                ),
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: const TimeOfDay(
                                      hour: 9,
                                      minute: 0,
                                    ),
                                  );

                                  if (picked != null) {
                                    dialogSetState(() {
                                      fromController.text =
                                          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                                    });

                                    calculateHours(dialogSetState);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10),

                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: toController,
                                readOnly: true,
                                style: const TextStyle(
                                  color: Color(0xFF90CAF9),
                                ),
                                decoration: InputDecoration(
                                  labelText: "Select End Time",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF90CAF9),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.access_time,
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
                                      color: Color.fromARGB(255, 20, 20, 20),
                                      width: 1.5,
                                    ),
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                ),
                                onTap: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: const TimeOfDay(
                                      hour: 17,
                                      minute: 0,
                                    ),
                                  );

                                  if (picked != null) {
                                    dialogSetState(() {
                                      toController.text =
                                          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                                    });

                                    calculateHours(dialogSetState);
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 10),

                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: hoursController,
                                readOnly: true,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Color(0xFF90CAF9),
                                      content: Text(
                                        "Select Start and End Time to calculate working hours",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            20,
                                            20,
                                            20,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                style: const TextStyle(
                                  color: Color(0xFF90CAF9),
                                ),
                                decoration: InputDecoration(
                                  labelText: "Working Hours",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF90CAF9),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.hourglass_bottom,
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
                                      color: Color.fromARGB(255, 20, 20, 20),
                                      width: 1.5,
                                    ),
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: titleController,
                          style: const TextStyle(color: Color(0xFF90CAF9)),
                          decoration: InputDecoration(
                            hintText: "Task Title",
                            hintStyle: const TextStyle(
                              color: Color(0xFF90CAF9),
                            ),
                            prefixIcon: const Icon(
                              Icons.task_alt_rounded,
                              color: Color(0xFF90CAF9),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 20, 20, 20),

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

                        const SizedBox(height: 10),

                        TextField(
                          controller: challengeController,
                          style: const TextStyle(color: Color(0xFF90CAF9)),
                          decoration: InputDecoration(
                            hintText: "Challenges Faced",
                            hintStyle: const TextStyle(
                              color: Color(0xFF90CAF9),
                            ),
                            prefixIcon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFF90CAF9),
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 20, 20, 20),

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

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 120,
                          child: TextField(
                            controller: descriptionController,
                            expands: true,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(color: Color(0xFF90CAF9)),
                            decoration: InputDecoration(
                              hintText: "Describe today's work...",
                              hintStyle: const TextStyle(
                                color: Color(0xFF90CAF9),
                              ),

                              prefixIcon: const Icon(
                                Icons.description_outlined,
                                color: Color(0xFF90CAF9),
                              ),

                              filled: true,
                              fillColor: const Color.fromARGB(255, 20, 20, 20),

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

                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Wrap(
                          spacing: 12, // horizontal gap
                          runSpacing: 12, // vertical gap
                          children: [
                            // Add Image Button
                            InkWell(
                              onTap: () async {
                                final picked =
                                    await ImagePickerHelper.pickImage();
                                if (picked == null) return;

                                final path = await ImageHelper.saveImage(
                                  picked,
                                  widget.projectName,
                                );

                                dialogSetState(() {
                                  images.add(path!);
                                });
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 20, 20, 20),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF90CAF9,
                                    ).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.add_photo_alternate_rounded,
                                      color: Color(0xFF90CAF9),
                                      size: 32,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "Add",
                                      style: TextStyle(
                                        color: Color(0xFF90CAF9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Images
                            ...images.map((path) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showImagePreview(context, path);
                                      },
                                      child: Image.file(
                                        File(path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      ),
                                    ),

                                    Positioned(
                                      right: 6,
                                      top: 6,
                                      child: InkWell(
                                        onTap: () {
                                          dialogSetState(() {
                                            images.remove(path);
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            // Add Link Button
                            InkWell(
                              onTap: () async {
                                final link = await addLink();

                                if (link != null) {
                                  dialogSetState(() {
                                    links.add(link);
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 120,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 20, 20, 20),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF90CAF9,
                                    ).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_link,
                                      color: Color(0xFF90CAF9),
                                      size: 24,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Add Link",
                                      style: TextStyle(
                                        color: Color(0xFF90CAF9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Existing Links
                            ...links.map((link) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () async {
                                  final edited = await addLink(
                                    existingLink: link,
                                  );

                                  if (edited != null) {
                                    dialogSetState(() {
                                      final index = links.indexOf(link);
                                      links[index] = edited;
                                    });
                                  }
                                },
                                child: Container(
                                  width: 150,
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      25,
                                      25,
                                      25,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF90CAF9,
                                      ).withOpacity(0.25),
                                      width: 1.2,
                                    ),
                                  ),

                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.link,
                                        color: Color(0xFF90CAF9),
                                        size: 22,
                                      ),

                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              link["title"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xFF90CAF9),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              link["url"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xFF90CAF9),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          dialogSetState(() {
                                            links.remove(link);
                                          });
                                        },

                                        child: const Icon(
                                          Icons.close,
                                          color: Color(0xFF90CAF9),
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF90CAF9),
                              foregroundColor: Color.fromARGB(255, 20, 20, 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              if (editIndex == null) {
                                if (entries.length >= 7) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        20,
                                        20,
                                        20,
                                      ),
                                      content: Text(
                                        "Maximum 7 days allowed",
                                        style: TextStyle(
                                          color: Color(0xFF90CAF9),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );

                                  return;
                                }

                                entries.add({
                                  "day": entries.length + 1,

                                  "date": dateController.text,

                                  "from": fromController.text,
                                  "to": toController.text,
                                  "hours": workingHours,

                                  "title": titleController.text,

                                  "challenges": challengeController.text,

                                  "description": descriptionController.text,

                                  "images": images,

                                  "links": links,
                                });
                              } else {
                                entries[editIndex] = {
                                  "day": entries[editIndex]["day"],

                                  "date": dateController.text,

                                  "from": fromController.text,
                                  "to": toController.text,
                                  "hours": workingHours,

                                  "title": titleController.text,

                                  "challenges": challengeController.text,

                                  "description": descriptionController.text,
                                  "images": images,
                                  "links": links,
                                };
                              }

                              await saveWeekData();

                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save,
                                  color: Color.fromARGB(255, 20, 20, 20),
                                ),
                                SizedBox(width: 10),
                                const Text(
                                  "SAVE",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 20, 20, 20),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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

  Future<void> deleteEntry(int index) async {
    entries.removeAt(index);

    for (int i = 0; i < entries.length; i++) {
      entries[i]["day"] = i + 1;
    }

    await saveWeekData();

    setState(() {});
  }

  Future<void> editWeekTitle() async {
    TextEditingController titleController = TextEditingController(
      text: weekTitle,
    );

    TextEditingController summaryController = TextEditingController(
      text: weekSummary,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: SizedBox(
                width: 550,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_view_week_rounded,
                            color: Color(0xFF90CAF9),
                            size: 28,
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            "Week Details",
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xFF90CAF9),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      TextField(
                        controller: titleController,
                        style: const TextStyle(color: Color(0xFF90CAF9)),
                        decoration: InputDecoration(
                          hintText: "Week Title",
                          hintStyle: const TextStyle(color: Color(0xFF90CAF9)),
                          prefixIcon: const Icon(
                            Icons.task_alt_rounded,
                            color: Color(0xFF90CAF9),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 20, 20, 20),

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
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextField(
                        controller: summaryController,
                        maxLines: 5,
                        style: const TextStyle(color: Color(0xFF90CAF9)),
                        decoration: InputDecoration(
                          hintText: "Week Summary",
                          hintStyle: const TextStyle(color: Color(0xFF90CAF9)),
                          prefixIcon: const Icon(
                            Icons.notes_rounded,
                            color: Color(0xFF90CAF9),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 20, 20, 20),

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

                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF90CAF9),
                            foregroundColor: Color.fromARGB(255, 20, 20, 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            weekTitle = titleController.text;
                            weekSummary = summaryController.text;

                            await saveWeekData();

                            setState(() {});

                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.save_rounded),
                          label: const Text(
                            "Save Details",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 12, 12),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disables default back button
        leading: Tooltip(
          message: 'Go back to Projects', // Your custom hover text hint
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

        title: Text(
          weekTitle.trim().isEmpty
              ? "Week ${widget.weekNumber}"
              : "Week ${widget.weekNumber} - $weekTitle",
          style: const TextStyle(
            color: Color(0xFF90CAF9),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF90CAF9), // Your custom blue color
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF90CAF9)),
            onPressed: editWeekTitle,
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final item = entries[index];

          return Card(
            margin: const EdgeInsets.all(15),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            shadowColor: Color(0xFF90CAF9),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Day ${item["day"]}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF90CAF9),
                        ),
                      ),

                      SizedBox(width: 5),
                      Container(width: 1, height: 32, color: Color(0xFF90CAF9)),
                      SizedBox(width: 10),
                      Text(
                        "Date: ",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        item["date"],
                        style: const TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 22,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF90CAF9)),
                        onPressed: () {
                          showEntryDialog(entry: item, editIndex: index);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                  size: 36,
                                ),

                                title: const Text(
                                  "Delete Day",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                content: SizedBox(
                                  width: 350,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 20, 20, 20),
                                        fontSize: 14,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text:
                                              'Are you sure you want to delete ',
                                        ),
                                        TextSpan(
                                          text: 'Day ${item["day"]}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF90CAF9),
                                          ),
                                        ),
                                        const TextSpan(text: '?'),
                                      ],
                                    ),
                                  ),
                                ),

                                actionsAlignment: MainAxisAlignment.center,

                                actions: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogContext, false);
                                    },
                                    child: const Text("Cancel"),
                                  ),

                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(dialogContext, true);
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldDelete == true) {
                            await deleteEntry(index);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Container(height: 1, color: Color(0xFF90CAF9)),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        "Working Duration: ",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            formatTime12Hour(item["from"]),
                            style: TextStyle(
                              color: Color(0xFF90CAF9),
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            " - ",
                            style: TextStyle(
                              color: Color(0xFF90CAF9),
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            formatTime12Hour(item["to"]),
                            style: TextStyle(
                              color: Color(0xFF90CAF9),
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Text(
                        "Working Hours: ",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),

                      Text(
                        "${item["hours"]} hrs",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Text(
                        "Task: ",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        item["title"],
                        style: const TextStyle(
                          color: Color(0xFF90CAF9),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Challenges: ",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${item["challenges"]}",
                          style: const TextStyle(
                            color: Color(0xFF90CAF9),
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description: ",
                        style: TextStyle(
                          color: Color(0xFF90CAF9),
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${item["description"]}",
                          style: const TextStyle(
                            color: Color(0xFF90CAF9),
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  if ((item["images"] ?? []).isNotEmpty)
                    const Text(
                      "ScreenShots:",
                      style: TextStyle(
                        color: Color(0xFF90CAF9),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 16,

                    children: (item["images"] as List).map((path) {
                      return InkWell(
                        onTap: () {
                          showImagePreview(context, path);
                        },
                        child: Image.file(
                          File(path),
                          width: 240,
                          height: 240,
                          fit: BoxFit.contain,
                        ),
                      );
                    }).toList(),
                  ),

                  if ((item["links"] ?? []).isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const SizedBox(height: 10),

                        const Text(
                          "Links:",
                          style: TextStyle(
                            color: Color(0xFF90CAF9),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),

                        ...(item["links"] as List).map((link) {
                          return InkWell(
                            onTap: () async {
                              final uri = Uri.parse(link["url"]);

                              try {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              } catch (e) {
                                print("URL Error: $e");
                              }
                            },

                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),

                              child: Text(
                                link["title"],

                                style: const TextStyle(
                                  color: Color(0xFF90CAF9),
                                  decoration: TextDecoration.underline,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF90CAF9),
        onPressed: () {
          showEntryDialog();
        },
        child: const Icon(Icons.add, color: Color.fromARGB(255, 20, 20, 20)),
      ),
    );
  }
}
