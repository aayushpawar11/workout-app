# Workout App

A simple iOS workout tracking app built with SwiftUI that helps you organize workouts, track exercises, and monitor your progress over time.

## Features

- **Create Custom Workouts**: Organize your training into workout routines (e.g., "Upper Day 1", "Lower Day 2")
- **Exercise Management**: Add exercises to each workout with muscle group targeting
- **Body Diagram Visualization**: View color-coded body diagrams showing which muscle groups are targeted in each workout
- **Workout Tracking**: Log sets, reps, and weight for each exercise
- **Progress Graphs**: Visualize weight progression over time with interactive charts
- **Data Persistence**: All your workouts and progress are saved locally on your device

## Setup Instructions

### Prerequisites
- macOS with Xcode 14.0 or later
- iOS 17.0 or later (for deployment target)

### Installation

1. **Open in Xcode**:
   - Open Xcode
   - Select "Open a project or file"
   - Navigate to the `workout-app` folder
   - Open `workout-app.xcodeproj`

2. **Configure Signing**:
   - Select the project in the navigator
   - Go to "Signing & Capabilities"
   - Select your development team
   - Xcode will automatically manage provisioning

3. **Build and Run**:
   - Select your target device (simulator or physical device)
   - Press `Cmd + R` or click the Run button
   - The app will build and launch

## Usage Guide

### Creating Workouts

1. Tap the "+" button in the top right of the Workouts tab
2. Enter a workout name (e.g., "Upper Day 1")
3. Tap "Save"

### Adding Exercises

1. Select a workout from the list
2. Tap the "+" button in the top right
3. Enter the exercise name (e.g., "Bench Press")
4. Select the muscle groups targeted by the exercise
5. Tap "Save"

### Viewing Body Diagram

1. Open any workout
2. Tap "View Body Diagram" at the top
3. See color-coded front and back views showing which muscles are targeted
4. A legend shows all targeted muscle groups

### Tracking Workouts

1. Select an exercise from a workout
2. Set the number of sets, reps, and weight
3. Tap "Save Workout" to log the session
4. View your workout history by tapping "View Progress"

### Viewing Progress Graphs

1. Navigate to the "Progress" tab
2. Select an exercise from the dropdown
3. View your weight progression over time
4. See statistics including total workouts, max weight, and average weight
5. Tap "Reset Progress Data" to delete all logs for that exercise (with confirmation)

## Project Structure

```
workout-app/
├── workout_appApp.swift          # App entry point
├── Models/
│   ├── Workout.swift             # Data models (Workout, Exercise, MuscleGroup, WorkoutLog)
│   └── WorkoutDataStore.swift    # Data persistence and management
├── Views/
│   ├── ContentView.swift         # Main tab view
│   ├── WorkoutListView.swift     # List of all workouts
│   ├── AddWorkoutView.swift      # Create new workout
│   ├── WorkoutDetailView.swift   # Workout details with exercises
│   ├── AddExerciseView.swift     # Add exercise to workout
│   ├── ExerciseTrackingView.swift # Track sets/reps/weight
│   ├── BodyDiagramView.swift     # Color-coded body diagram
│   └── GraphView.swift           # Progress charts and graphs
└── Assets.xcassets/              # App icons and assets
```

## Data Storage

The app uses `UserDefaults` to persist data locally on your device. All workouts, exercises, and workout logs are automatically saved and restored when you open the app.

## Muscle Groups

The app supports tracking the following muscle groups:
- Chest
- Back
- Shoulders
- Biceps
- Triceps
- Forearms
- Abs
- Quads
- Hamstrings
- Glutes
- Calves

Each muscle group has a unique color for easy identification in the body diagram.

## Requirements

- iOS 17.0+
- Xcode 14.0+
- Swift 5.0+

## License

See LICENSE file for details.
