import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // MOCK ATTENDANCE DATA (For future merging)
  // Format: DateTime -> Status ('present', 'absent', 'half-day')
  Map<DateTime, String> _attendanceData = {};

  // Helper to normalize dates (removes time component for accurate map matching)
  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  Future<File> _getStreakConfigurationFile() async {
  final directory = await getApplicationDocumentsDirectory();

  final folder = Directory(
      "${directory.path}/DailyReportGenerator/system");

  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  return File("${folder.path}/streak.json");
}

Future<void> _loadAttendance() async {
  final file = await _getStreakConfigurationFile();

  if (!await file.exists()) return;

  final json = jsonDecode(await file.readAsString());

  final attendance = Map<String, dynamic>.from(
    json["attendance"] ?? {},
  );

  _attendanceData.clear();

  attendance.forEach((key, value) {
    final date = DateTime.parse(key);

    _attendanceData[
      DateTime.utc(
        date.year,
        date.month,
        date.day,
      )
    ] = value;
  });

  setState(() {});
}

@override
void initState() {
  super.initState();

  _loadAttendance();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 12, 12),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Calendar',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF90CAF9),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Container(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Calendar Card Container
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 20, 20, 20),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF90CAF9),
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,

                          // Selection Logic
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay; // update focused day
                            });

                            // TODO: Handle click action (e.g., show bottom sheet to mark attendance)
                            print("Selected Date: $selectedDay");
                          },

                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },

                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },

                          // Styling configuration
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            titleCentered: true,
                            formatButtonDecoration: BoxDecoration(
                              color: Color(0xFF90CAF9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            formatButtonTextStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 20, 20),
                              fontWeight: FontWeight.bold,
                            ),
                            titleTextStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF90CAF9),
                            ),
                            leftChevronIcon: const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF90CAF9),
                            ),
                            rightChevronIcon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF90CAF9),
                            ),
                          ),

                          daysOfWeekStyle: DaysOfWeekStyle(
                            // Styling for weekdays (Mon - Fri)
                            weekdayStyle: TextStyle(
                              color: Color(0xFF90CAF9), // Change to your desired color
                              fontWeight: FontWeight.bold,
                            ),
                            // Styling for weekends (Sat - Sun)
                            weekendStyle: TextStyle(
                              color: Colors
                                  .redAccent, // Change to your desired color
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            weekendTextStyle: const TextStyle(
                              color: Colors.redAccent,
                            ),
                            defaultTextStyle: const TextStyle(
                              color: Color(0xFF90CAF9),
                              fontWeight: FontWeight.w500,
                            ),

                            // Today Styling
                            todayDecoration: BoxDecoration(
                              color: Colors.deepPurple.shade100,
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 169, 124, 245),
                              fontWeight: FontWeight.bold,
                            ),

                            // Selected Day Styling
                            selectedDecoration: const BoxDecoration(
                              color: Color.fromARGB(255, 63, 165, 248),
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // MARKERS FOR ATTENDANCE (Integration Point)
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              final normalizedDate = _normalizeDate(date);
                              final status = _attendanceData[normalizedDate];

                              if (status != null) {
                                return Positioned(
                                  bottom: 4,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getStatusColor(status),
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Legend Card for Attendance Status
                      _buildAttendanceLegend(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Color mapper for your attendance types
  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'half-day':
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  // Legend UI Widget
  Widget _buildAttendanceLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 20, 20, 20),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF90CAF9),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _legendItem(Colors.green, 'Present'),
          _legendItem(Colors.red, 'Absent'),
          _legendItem(Colors.orange, 'Half-Day'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0xFF90CAF9),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF90CAF9),
          ),
        ),
      ],
    );
  }
}
