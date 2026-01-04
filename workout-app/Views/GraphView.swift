import SwiftUI
import Charts

struct GraphView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    @State private var selectedExerciseId: UUID?
    
    var allExercises: [Exercise] {
        dataStore.workouts.flatMap { $0.exercises }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if allExercises.isEmpty {
                    Text("No exercises yet. Create a workout and add exercises to track progress!")
                        .foregroundColor(.secondary)
                        .padding()
                        .multilineTextAlignment(.center)
                } else {
                    Form {
                        Section {
                            Picker("Select Exercise", selection: $selectedExerciseId) {
                                Text("Select an exercise").tag(nil as UUID?)
                                ForEach(allExercises) { exercise in
                                    Text(exercise.name).tag(exercise.id as UUID?)
                                }
                            }
                        }
                        
                        if let exerciseId = selectedExerciseId,
                           let exercise = allExercises.first(where: { $0.id == exerciseId }) {
                            Section {
                                ExerciseChartView(exercise: exercise)
                            } header: {
                                Text("Weight Progression")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Progress")
        }
    }
}

struct ExerciseChartView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    let exercise: Exercise
    @State private var showingResetAlert = false
    
    var logs: [WorkoutLog] {
        dataStore.getLogsForExercise(exercise.id)
    }
    
    var chartData: [(date: Date, weight: Double)] {
        logs.map { (date: $0.date, weight: $0.weight) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if logs.isEmpty {
                Text("No workout data yet. Start tracking your workouts!")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                Chart {
                    ForEach(Array(chartData.enumerated()), id: \.offset) { index, data in
                        LineMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Weight", data.weight)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Date", data.date, unit: .day),
                            y: .value("Weight", data.weight)
                        )
                        .foregroundStyle(.blue)
                        .symbolSize(100)
                    }
                }
                .frame(height: 300)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: max(1, logs.count / 5))) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisValueLabel()
                    }
                }
                
                // Stats
                VStack(alignment: .leading, spacing: 8) {
                    Text("Statistics")
                        .font(.headline)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Workouts")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(logs.count)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Max Weight")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(logs.map { $0.weight }.max() ?? 0, specifier: "%.1f") lbs")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Average Weight")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(logs.map { $0.weight }.reduce(0, +) / Double(logs.count), specifier: "%.1f") lbs")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button(action: { showingResetAlert = true }) {
                    HStack {
                        Spacer()
                        Text("Reset Progress Data")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                dataStore.resetLogsForExercise(exercise.id)
            }
        } message: {
            Text("Are you sure you want to delete all progress data for \(exercise.name)? This action cannot be undone.")
        }
    }
}

struct ExerciseProgressView: View {
    @EnvironmentObject var dataStore: WorkoutDataStore
    let exercise: Exercise
    @Environment(\.dismiss) var dismiss
    
    var logs: [WorkoutLog] {
        dataStore.getLogsForExercise(exercise.id)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(logs.reversed()) { log in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(log.exerciseName)
                            .font(.headline)
                        Text("\(log.sets) sets × \(log.reps) reps @ \(log.weight, specifier: "%.1f") lbs")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(log.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Workout History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    GraphView()
        .environmentObject(WorkoutDataStore())
}

