# 📊 Daily Report Generator

A modern desktop application built with Flutter that helps students, interns, and professionals manage daily work logs and generate professional internship reports in PDF format.

---

## ✨ Features

### 📁 Project Management
- Create unlimited projects
- Organize reports by project
- Delete projects safely with confirmation dialogs
- Persistent local storage using JSON

### 📅 Weekly Reporting
- Create multiple weeks inside a project
- Edit week titles
- Add weekly summaries
- Automatic week numbering

### 📝 Daily Work Tracking
- Add up to 7 daily entries per week
- Track:
  - Date
  - Working Hours
  - Task Title
  - Challenges Faced
  - Detailed Description

### ✏️ Edit & Delete
- Modify existing entries anytime
- Delete entries with confirmation
- Automatic day reordering after deletion

### ⚙️ Project Settings
Store important internship information:

- Company Name
- Student Name
- College Name
- Internship Role
- Guide Name
- Start Date
- End Date
- Report Title

### 📄 Professional PDF Generation
Generate internship reports with:

- Cover Page
- Project Information
- Weekly Sections
- Daily Work Logs
- Weekly Summaries
- Professional Formatting
- Clean Document Layout

### 🎨 Modern UI
- Material Design
- Clean Cards
- Rounded Corners
- Modern Dialogs
- Responsive Layout
- Easy Navigation

---

# 🖥️ Platform Compatibility

| Platform | Status |
|-----------|---------|
| 🪟 Windows | ✅ Supported |
| 🤖 Android | 🚧 In Development |
| 🍎 macOS | 📅 Planned |
| 🐧 Linux | 📅 Planned |
| 🌐 Web | 📅 Planned |
| 📱 iOS | 📅 Planned |

---


# 💾 Data Storage

All project data is stored locally as JSON files.

```text
Documents/
└── DailyReportGenerator/
    └── projects/
        ├── Project1.json
        ├── Project2.json
        └── Project3.json
```

Example:

```json
{
  "projectName": "Internship Report",
  "settings": {
    "companyName": "ABC Technologies",
    "studentName": "John Doe"
  },
  "weeks": [
    {
      "week": 1,
      "title": "Flutter Development",
      "weekSummary": "Completed UI screens",
      "entries": []
    }
  ]
}
```

---

# 🚀 Getting Started

## Prerequisites

- Flutter SDK
- Dart SDK
- VS Code or Android Studio

---

## Installation

Clone repository

```bash
git clone https://github.com/yourusername/daily-report-generator.git
```

Open project

```bash
cd daily-report-generator
```

Install packages

```bash
flutter pub get
```

Run application

```bash
flutter run
```

---

# 📦 Dependencies

```yaml
dependencies:
  flutter:
  path_provider:
  pdf:
  printing:
```

---

# 📄 PDF Report Includes

### Cover Page

- Report Title
- Student Name
- Company Name
- Internship Role
- Guide Name
- Internship Duration

### Weekly Sections

Each week contains:

- Week Number
- Week Title
- Weekly Summary

### Daily Logs

Each day includes:

- Date
- Working Hours
- Task Title
- Challenges
- Description

---

# 🎯 Target Users

### Students

Maintain internship records professionally.

### Interns

Generate weekly and monthly reports easily.

### Professionals

Track daily work progress.

### Colleges

Use for internship submissions and documentation.

---

# 🔒 Offline First

The application works completely offline.

No:

- Login
- Cloud Storage
- Internet Requirement

All data remains on the user's device.

---

## Get Started

For product updates, release notes, documentation, and direct application downloads, visit the official website:

🌐 https://dailyreportgen.netlify.app/

The website provides:
- Latest application releases
- Installation guides
- Feature documentation
- Screenshots and demos
- Direct download links for pre-built binaries

No source-code setup required.

---

# 🛣️ Future Roadmap

## Version 2.0

- Dark Mode
- Export to DOCX
- Cloud Backup
- Project Templates
- Analytics Dashboard
- AI Summary Generation
- Multi-user Support
- Company Branding

---

# 🤝 Contribution

Contributions are welcome.

Steps:

1. Fork repository
2. Create feature branch

```bash
git checkout -b feature/new-feature
```

3. Commit changes

```bash
git commit -m "Added new feature"
```

4. Push branch

```bash
git push origin feature/new-feature
```

5. Create Pull Request

---

# 📜 License

MIT License

Copyright (c) 2026

---

# ❤️ Built With Flutter

Designed to simplify internship documentation and professional report generation.
