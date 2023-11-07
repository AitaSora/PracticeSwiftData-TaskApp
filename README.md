# PracticeSwiftData-TaskApp

## Description

This Task Management App allows users to create, manage, and reflect on tasks with varying priorities. Built using SwiftUI and SwiftData, the app categorizes tasks based on their priority levels and provides a detailed view of each task, including its name, description, rating, reflection, and completion date. Additionally, the app features a dedicated section for deleted tasks, allowing users to review or reflect upon completed tasks.

## Features

- **Task Listing:** Tasks are listed by priority levels: High, Medium, and Low.
- **Task Creation:** Users can add new tasks, specifying their name, description, and priority.
- **Task Detail View:** Users can view detailed information about each task, with a designated reflection section for completed tasks.
- **completed Tasks Section:** A special view to browse through completed tasks.
- **Search Functionality:** Users can search through completed　　tasks to find specific items quickly.
- **Interactive UI:** Swipe to delete tasks, and a floating action button for adding new tasks.
- **Reflection Section:** Users can reflect on completed tasks, rating them and jotting down any reflections.
- **Custom Back Button:** The back button on the task detail view can be customized for better navigation clarity.

## Usage

1. **Home Screen**
   - The Home screen lists all tasks categorized by their priority.
   - Each task displays its name, and if not created today, its creation date.
   - Users can navigate to the task detail view by tapping on a task.
   - Two floating action buttons at the bottom allow for navigation to the completed Tasks view and the New Task creation view.

2. **Task Detail View**
   - Displays detailed information about a task, including a section for reflections if the task is completed.
   - Users can navigate back to the task listing view using the custom back button labeled "Task List".

3. **Deleted Tasks View**
   - Lists all completed tasks.
   - Provides a search functionality for easier navigation.
   - Users can navigate to a detailed view of each deleted task.

4. **New Task Creation View**
   - A simple form for creating new tasks, specifying the task name, description, and priority level.

## Installation

Ensure you have Xcode installed on your Mac. Clone the repository, open the project in Xcode, and run the app in the simulator or on your device.

```bash
git clone https://github.com/your-repository-url/TaskManagementApp.git
cd TaskManagementApp
open TaskManagementApp.xcodeproj
```

## Dependencies

- SwiftUI for UI.
- SwiftData for data management.

## Contributing

If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are warmly welcome.

---
