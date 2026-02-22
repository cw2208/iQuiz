//
//  Quiz.swift
//  iQuiz
//
//  Created by Christina Wang on 2/22/26.
//
import Foundation

enum QuizServiceError: Error {
    case badURL
    case noData
}

final class QuizService {
    static func fetchQuizzes(from urlString: String, completion: @escaping (Result<[RemoteQuiz], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(QuizServiceError.badURL))
            return
        }

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(QuizServiceError.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode([RemoteQuiz].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
