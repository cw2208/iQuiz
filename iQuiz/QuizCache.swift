//
//  QuizCache.swift
//  iQuiz
//
//  Created by Christina Wang on 2/22/26.
//
import Foundation

final class QuizCache {

    static let shared = QuizCache()

    private init() {}

    private var fileURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docs.appendingPathComponent("quizzes.json")
    }

    func save(data: Data) {
        do {
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("QuizCache save error:", error)
        }
    }

    func load() -> Data? {
        return try? Data(contentsOf: fileURL)
    }

    func hasCache() -> Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }
}
