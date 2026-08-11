import 'dart:convert';
import 'dart:io';

import 'package:dailyreport/pages/weekDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'pdfpreviewpage.dart';
import '../widget/modernfeild.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectName;

  const ProjectDetailPage({super.key, required this.projectName});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  List<Map<String, dynamic>> weeks = [];
  Map<String, dynamic> projectSettings = {
    "companyName": "",
    "studentName": "",
    "collegeName": "",
    "internshipRole": "",
    "startDate": "",
    "endDate": "",
    "guideName": "",
    "title": "",
    "studentNameLabel": "Student Name",
    "companyNameLabel": "Company Name",
    "collegeNameLabel": "College Name",
    "internshipRoleLabel": "Role",
    "guideNameLabel": "Guide Name",
    "durationLabel": "Duration",
  };

  @override
  void initState() {
    super.initState();
    loadProject();
  }

  Future<File> getProjectFile() async {
    final docs = await getApplicationDocumentsDirectory();

    final projectDir = Directory('${docs.path}/DailyReportGenerator/projects');

    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }

    final fileName = widget.projectName.replaceAll(' ', '_');

    return File('${projectDir.path}/$fileName.json');
  }

  Future<void> loadProject() async {
    final file = await getProjectFile();

    if (!await file.exists()) {
      return;
    }

    final jsonData = jsonDecode(await file.readAsString());

    if (jsonData["weeks"] != null) {
      weeks = List<Map<String, dynamic>>.from(jsonData["weeks"]);
    }
    if (jsonData["settings"] != null) {
      projectSettings = Map<String, dynamic>.from(jsonData["settings"]);
    }

    setState(() {});
  }

  Future<void> saveSettings() async {
    final file = await getProjectFile();

    if (!await file.exists()) {
      return;
    }

    final jsonData = jsonDecode(await file.readAsString());

    jsonData["settings"] = projectSettings;

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(jsonData),
    );

    print("saved setting");
  }

  Future<void> saveProject() async {
    final file = await getProjectFile();

    Map<String, dynamic> data = {
      "projectName": widget.projectName,
      "weeks": weeks,
      "settings": projectSettings,
    };

    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  }

  Future<void> addWeek() async {
    int weekNumber = weeks.length + 1;

    weeks.add({
      "week": weekNumber,
      "title": "",
      "weekSummary": "",
      "entries": [],
    });

    await saveProject();

    setState(() {});
  }

  Future<void> deleteWeek(int index) async {
    weeks.removeAt(index);

    for (int i = 0; i < weeks.length; i++) {
      weeks[i]["week"] = i + 1;
    }

    await saveProject();

    setState(() {});
  }

  void showSettingsDialog() {
    final companyController = TextEditingController(
      text: projectSettings["companyName"],
    );

    final studentController = TextEditingController(
      text: projectSettings["studentName"],
    );

    final collegeController = TextEditingController(
      text: projectSettings["collegeName"],
    );

    final roleController = TextEditingController(
      text: projectSettings["internshipRole"],
    );

    final startDateController = TextEditingController(
      text: projectSettings["startDate"] ?? "",
    );

    final endDateController = TextEditingController(
      text: projectSettings["endDate"] ?? "",
    );
    final guideController = TextEditingController(
      text: projectSettings["guideName"] ?? "",
    );
    final titleController = TextEditingController(
      text: projectSettings["title"] ?? "",
    );

    final studentNameLabelController = TextEditingController(
      text: projectSettings["studentNameLabel"] ?? "Student Name",
    );

    final companyNameLabelController = TextEditingController(
      text: projectSettings["companyNameLabel"] ?? "Company Name",
    );

    final collegeNameLabelController = TextEditingController(
      text: projectSettings["collegeNameLabel"] ?? "College Name",
    );

    final guideNameLabelController = TextEditingController(
      text: projectSettings["guideNameLabel"] ?? "Guide Name",
    );

    final internshipRoleLabelController = TextEditingController(
      text: projectSettings["internshipRoleLabel"] ?? "Role",
    );

    final durationLabelController = TextEditingController(
      text: projectSettings["durationLabel"] ?? "Duration",
    );

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          child: SizedBox(
            width: 600,
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings_rounded,
                                color: Color(0xFF90CAF9),
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Project Settings",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF90CAF9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          modernField(
                            controller: companyController,
                            hint: "Company Name",
                            icon: Icons.business_rounded,
                          ),

                          const SizedBox(height: 20),
                          modernField(
                            controller: titleController,
                            hint: "Report Title",
                            icon: Icons.description_rounded,
                          ),

                          const SizedBox(height: 20),
                          modernField(
                            controller: studentController,
                            hint: "Student Name",
                            icon: Icons.person_rounded,
                          ),
                          const SizedBox(height: 10),

                          modernField(
                            controller: collegeController,
                            hint: "College Name",
                            icon: Icons.school_rounded,
                          ),
                          const SizedBox(height: 10),

                          modernField(
                            controller: roleController,
                            hint: "Internship Role",
                            icon: Icons.work_rounded,
                          ),
                          const SizedBox(height: 10),

                          modernField(
                            controller: guideController,
                            hint: "Guide Name",
                            icon: Icons.supervisor_account_rounded,
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: modernField(
                                  controller: startDateController,
                                  hint: "Start Date",
                                  icon: Icons.calendar_today_rounded,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );

                                    if (picked != null) {
                                      startDateController.text =
                                          "${picked.day.toString().padLeft(2, '0')}-"
                                          "${picked.month.toString().padLeft(2, '0')}-"
                                          "${picked.year}";
                                    }
                                  },
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: modernField(
                                  controller: endDateController,
                                  hint: "End Date",
                                  icon: Icons.calendar_today_rounded,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );

                                    if (picked != null) {
                                      endDateController.text =
                                          "${picked.day.toString().padLeft(2, '0')}-"
                                          "${picked.month.toString().padLeft(2, '0')}-"
                                          "${picked.year}";
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Divider(),

                          const SizedBox(height: 10),

                          const Text(
                            "PDF Labels",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF90CAF9),
                            ),
                          ),

                          const SizedBox(height: 15),

                          modernField(
                            controller: studentNameLabelController,
                            hint: "Student Name Label",
                            icon: Icons.person,
                          ),

                          const SizedBox(height: 10),

                          modernField(
                            controller: companyNameLabelController,
                            hint: "Company Name Label",
                            icon: Icons.business,
                          ),

                          const SizedBox(height: 10),

                          modernField(
                            controller: collegeNameLabelController,
                            hint: "College Name Label",
                            icon: Icons.school,
                          ),

                          const SizedBox(height: 10),

                          modernField(
                            controller: internshipRoleLabelController,
                            hint: "Role Label",
                            icon: Icons.work_rounded,
                          ),

                          const SizedBox(height: 10),

                          modernField(
                            controller: guideNameLabelController,
                            hint: "Guide Label",
                            icon: Icons.supervisor_account_rounded,
                          ),

                          const SizedBox(height: 10),

                          modernField(
                            controller: durationLabelController,
                            hint: "Duration Label",
                            icon: Icons.timer,
                          ),

                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
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
                        // save code
                        projectSettings = {
                          "companyName": companyController.text,

                          "studentName": studentController.text,

                          "collegeName": collegeController.text,

                          "internshipRole": roleController.text,

                          "startDate": startDateController.text,
                          "endDate": endDateController.text,
                          "guideName": guideController.text,
                          "title": titleController.text,

                          // Labels
                          "studentNameLabel": studentNameLabelController.text,
                          "companyNameLabel": companyNameLabelController.text,
                          "collegeNameLabel": collegeNameLabelController.text,
                          "internshipRoleLabel":
                              internshipRoleLabelController.text,
                          "guideNameLabel": guideNameLabelController.text,
                          "durationLabel": durationLabelController.text,
                        };

                        await saveSettings();

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.save_rounded,
                            color: Color.fromARGB(255, 20, 20, 20),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "SAVE SETTING",
                            style: TextStyle(
                              color: Color.fromARGB(255, 20, 20, 20),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
          message: 'Go back to Dashboard', // Your custom hover text hint
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
        title: Text(
          "${widget.projectName} Project",
          style: const TextStyle(
            color: Color(0xFF90CAF9),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF90CAF9)),
            onPressed: showSettingsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF90CAF9)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PdfPreviewPage(projectName: widget.projectName),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 20, 20, 20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromARGB(255, 20, 20, 20),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF90CAF9),
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: weeks.isEmpty
              ? const Center(
                  child: Text(
                    "No Weeks Created",
                    style: TextStyle(
                      color: Color(0xFF90CAF9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: weeks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(15),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1,
                      shadowColor: Color(0xFF90CAF9),
                      child: ListTile(
                        leading: const Icon(
                          Icons.calendar_month,
                          color: Color(0xFF90CAF9),
                        ),

                        title: Text(
                          "Week ${weeks[index]["week"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF90CAF9),
                          ),
                        ),

                        subtitle: Text(
                          "${(weeks[index]["entries"] as List).length} Entries",
                          style: const TextStyle(color: Color(0xFF90CAF9)),
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool? shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                  size: 36,
                                ),

                                title: const Text(
                                  "Delete Week",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF90CAF9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                content: SizedBox(
                                  width: 350,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Color(0xFF90CAF9),
                                        fontSize: 14,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text:
                                              'Are you sure you want to delete ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF90CAF9),
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Week ${weeks[index]["week"]}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF90CAF9),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '?',
                                          style: TextStyle(
                                            color: Color(0xFF90CAF9),
                                          ),
                                        ),
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
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF90CAF9),
                                      ),
                                    ),
                                  ),

                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Color(0xFF90CAF9),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text(
                                      "Delete",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF90CAF9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldDelete == true) {
                              await deleteWeek(index);
                            }
                          },
                        ),

                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WeekDetailPage(
                                projectName: widget.projectName,
                                weekNumber: weeks[index]["week"],
                              ),
                            ),
                          );

                          // Reload project data after returning from WeekDetailPage
                          if (mounted) {
                            await loadProject();
                          }
                        },
                      ),
                    );
                  },
                ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF90CAF9),
        onPressed: addWeek,
        child: const Icon(Icons.add, color: Color.fromARGB(255, 20, 20, 20)),
      ),
    );
  }
}
