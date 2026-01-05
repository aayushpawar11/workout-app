import Foundation

class GeminiService {
    private let apiKey = "AIzaSyBm_KUwEOD5Nnq9yv0rSAN55hPfg1Croso"
    private let baseURL = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent"
    
    func analyzeExercise(_ exerciseName: String) async throws -> [DetailedMuscle] {
        let prompt = """
        You are a fitness expert. Analyze the exercise "\(exerciseName)" and determine which specific muscles it targets.
        
        Return ONLY a valid JSON array of muscle names from this exact list (use exact spelling):
        ["Upper Chest", "Mid Chest", "Lower Chest", "Upper Back", "Mid Back", "Lower Back", "Lats", "Traps", 
         "Anterior Deltoids", "Lateral Deltoids", "Posterior Deltoids", "Biceps", "Triceps", "Forearms",
         "Upper Abs", "Lower Abs", "Obliques", "Quads", "Hamstrings", "Glutes", "Calves"]
        
        Be precise: if an exercise targets upper chest, only include "Upper Chest", not "Mid Chest" or "Lower Chest".
        If it targets multiple specific regions, include all of them.
        Return ONLY the JSON array, no other text, no explanations, no markdown.
        
        Example response: ["Upper Chest", "Anterior Deltoids", "Triceps"]
        """
        
        let requestBody: [String: Any] = [
            "contents": [[
                "parts": [[
                    "text": prompt
                ]]
            ]]
        ]
        
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw GeminiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.requestFailed
        }
        
        if httpResponse.statusCode != 200 {
            print("Gemini API Error: Status \(httpResponse.statusCode)")
            if let errorData = String(data: data, encoding: .utf8) {
                print("Error response: \(errorData)")
            }
            throw GeminiError.requestFailed
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw GeminiError.invalidResponse
        }
        
        guard let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw GeminiError.invalidResponse
        }
        
        // Parse the JSON array from the response
        var cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove markdown code blocks if present
        if cleanedText.hasPrefix("```json") {
            cleanedText = String(cleanedText.dropFirst(7))
        }
        if cleanedText.hasPrefix("```") {
            cleanedText = String(cleanedText.dropFirst(3))
        }
        if cleanedText.hasSuffix("```") {
            cleanedText = String(cleanedText.dropLast(3))
        }
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Try to find JSON array in the text
        if let jsonStart = cleanedText.range(of: "["),
           let jsonEnd = cleanedText.range(of: "]", range: jsonStart.upperBound..<cleanedText.endIndex) {
            cleanedText = String(cleanedText[jsonStart.lowerBound...jsonEnd.upperBound])
        }
        
        guard let jsonData = cleanedText.data(using: .utf8),
              let muscleNames = try? JSONSerialization.jsonObject(with: jsonData) as? [String] else {
            print("Failed to parse JSON. Text was: \(cleanedText)")
            throw GeminiError.invalidResponse
        }
        
        // Convert string names to DetailedMuscle enum cases
        let muscles = muscleNames.compactMap { name -> DetailedMuscle? in
            DetailedMuscle.allCases.first { $0.rawValue == name }
        }
        
        return muscles
    }
}

enum GeminiError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}
