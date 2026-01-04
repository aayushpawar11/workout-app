import Foundation
import SwiftUI

class WorkoutDataStore: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var workoutLogs: [WorkoutLog] = []
    
    private let workoutsKey = "saved_workouts"
    private let logsKey = "saved_workout_logs"
    
    init() {
        loadWorkouts()
        loadLogs()
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        saveWorkouts()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            saveWorkouts()
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        saveWorkouts()
    }
    
    func addExercise(_ exercise: Exercise, to workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].exercises.append(exercise)
            saveWorkouts()
        }
    }
    
    func deleteExercise(_ exercise: Exercise, from workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].exercises.removeAll { $0.id == exercise.id }
            saveWorkouts()
        }
    }
    
    func logWorkout(_ log: WorkoutLog) {
        workoutLogs.append(log)
        saveLogs()
    }
    
    func getLogsForExercise(_ exerciseId: UUID) -> [WorkoutLog] {
        workoutLogs.filter { $0.exerciseId == exerciseId }
            .sorted { $0.date < $1.date }
    }
    
    func resetLogsForExercise(_ exerciseId: UUID) {
        workoutLogs.removeAll { $0.exerciseId == exerciseId }
        saveLogs()
    }
    
    private func saveWorkouts() {
        if let encoded = try? JSONEncoder().encode(workouts) {
            UserDefaults.standard.set(encoded, forKey: workoutsKey)
        }
    }
    
    private func loadWorkouts() {
        if let data = UserDefaults.standard.data(forKey: workoutsKey),
           let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
            workouts = decoded
        }
    }
    
    private func saveLogs() {
        if let encoded = try? JSONEncoder().encode(workoutLogs) {
            UserDefaults.standard.set(encoded, forKey: logsKey)
        }
    }
    
    private func loadLogs() {
        if let data = UserDefaults.standard.data(forKey: logsKey),
           let decoded = try? JSONDecoder().decode([WorkoutLog].self, from: data) {
            workoutLogs = decoded
        }
    }
}

