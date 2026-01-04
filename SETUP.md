# Setup Guide

## Option 1: Use Existing Project File (Recommended)

1. Open Xcode
2. Open `workout-app.xcodeproj`
3. If files are missing from the project:
   - Right-click on the project navigator
   - Select "Add Files to workout-app..."
   - Navigate to the `workout-app` folder
   - Select all Swift files in `Models/` and `Views/` folders
   - Make sure "Copy items if needed" is unchecked
   - Make sure "Create groups" is selected
   - Click "Add"

## Option 2: Create New Project in Xcode

If the project file doesn't work, follow these steps:

1. **Create New Project**:
   - Open Xcode
   - Select "Create a new Xcode project"
   - Choose "iOS" → "App"
   - Product Name: `workout-app`
   - Interface: SwiftUI
   - Language: Swift
   - Save in the parent directory (not inside workout-app folder)

2. **Replace Default Files**:
   - Delete the default `ContentView.swift` that Xcode created
   - Copy all files from the `workout-app` folder into your new project

3. **Add Files to Project**:
   - Right-click on the project name in navigator
   - Select "Add Files to workout-app..."
   - Add all files from:
     - `workout-app/Models/` folder
     - `workout-app/Views/` folder
     - `workout-app/workout_appApp.swift`
   - Make sure "Copy items if needed" is unchecked
   - Make sure "Create groups" is selected

4. **Configure Build Settings**:
   - Select the project in navigator
   - Go to "Build Settings"
   - Set "iOS Deployment Target" to 17.0 or higher

5. **Build and Run**:
   - Select a simulator or device
   - Press Cmd+R to build and run

## File Structure

Make sure your project has this structure:

```
workout-app/
├── workout_appApp.swift
├── Models/
│   ├── Workout.swift
│   └── WorkoutDataStore.swift
├── Views/
│   ├── ContentView.swift
│   ├── WorkoutListView.swift
│   ├── AddWorkoutView.swift
│   ├── WorkoutDetailView.swift
│   ├── AddExerciseView.swift
│   ├── ExerciseTrackingView.swift
│   ├── BodyDiagramView.swift
│   └── GraphView.swift
└── Assets.xcassets/
```

## Troubleshooting

- **Build Errors**: Make sure all Swift files are added to the target
- **Missing Files**: Use "Add Files to..." to add any missing files
- **Charts Not Showing**: Make sure you're using iOS 17+ (Charts framework requires iOS 16+)
- **Preview Not Working**: Make sure all files are properly added to the project

