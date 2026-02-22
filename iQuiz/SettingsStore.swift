//
//  SettingsStore.swift
//  iQuiz
//
//  Created by Christina Wang on 2/22/26.
//
import Foundation

final class SettingsStore {
    static let shared = SettingsStore()
    private init() {}

    private let urlKey = "quizSourceURL"
    private let intervalKey = "refreshIntervalSeconds"

    private let defaultURLString = "http://tednewardsandbox.site44.com/questions.json"

    var quizSourceURLString: String {
        get { UserDefaults.standard.string(forKey: urlKey) ?? defaultURLString }
        set { UserDefaults.standard.set(newValue, forKey: urlKey) }
    }

    var refreshIntervalSeconds: Int {
        get { UserDefaults.standard.integer(forKey: intervalKey) == 0 ? 0 : UserDefaults.standard.integer(forKey: intervalKey) }
        set { UserDefaults.standard.set(newValue, forKey: intervalKey) }
    }

    var quizSourceURL: URL? {
        URL(string: quizSourceURLString.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
