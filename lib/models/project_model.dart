class ProjectModel {
  String id;
  String name;
  List<ReportEntry> entries;

  ProjectModel({
    required this.id,
    required this.name,
    required this.entries,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      name: json['name'],
      entries: (json['entries'] as List)
          .map((e) => ReportEntry.fromJson(e))
          .toList(),
    );
  }
}

class ReportEntry {
  String date;
  String title;
  String description;
  List<String> imagePaths;
  List<String> links;

  ReportEntry({
    required this.date,
    required this.title,
    required this.description,
    required this.imagePaths,
    required this.links,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'title': title,
      'description': description,
      'imagePaths': imagePaths,
      'links': links,
    };
  }

  factory ReportEntry.fromJson(Map<String, dynamic> json) {
    return ReportEntry(
      date: json['date'],
      title: json['title'],
      description: json['description'],
      imagePaths: json['imagePaths'] as List<String>,
      links: json['links'] as List<String>,
    );
  }
}