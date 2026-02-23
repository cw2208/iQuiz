//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Christina Wang on 2/14/26.
//
import UIKit

class QuizListViewController: UITableViewController {

    // MARK: - Settings / Defaults
    private let defaultQuizURL = "http://tednewardsandbox.site44.com/questions.json"
    private let urlKey = "quiz_url"

    // MARK: - Data
    private var quizzes: [Quiz] = []
    private var lastLoadedURL: String = ""

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "iQuiz"

        // Settings button -> opens Apple Settings app (Part 4 requirement)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )

        // Pull-to-refresh (Part 3 extra credit)
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appCameBack),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        // Kickstart network monitor
        _ = NetworkMonitor.shared

        // Initial load
        downloadAndReload()
    }
    
    @objc private func appCameBack() {
        downloadAndReload()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // If user changed URL in Apple Settings, reload next time we come back
        let current = currentQuizURL()
        if current != lastLoadedURL {
            downloadAndReload()
        }
    }

    // MARK: - Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quizzes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TopicCell")
        let quiz = quizzes[indexPath.row]

        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.desc
        cell.imageView?.image = UIImage(systemName: quiz.iconName)
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowQuestion", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowQuestion",
           let indexPath = sender as? IndexPath,
           let vc = segue.destination as? QuestionViewController {
            vc.quiz = quizzes[indexPath.row]
        }
    }

    // MARK: - Actions
    @objc private func didTapSettings() {
        // Opens iOS Settings -> your app settings (Part 4)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    @objc private func pulledToRefresh() {
        downloadAndReload()
    }

    // MARK: - Download + Offline Cache
    private func downloadAndReload() {
        let urlString = currentQuizURL()
        lastLoadedURL = urlString

        // If offline, try cache immediately
        if !NetworkMonitor.shared.isConnected {
            refreshControl?.endRefreshing()
            if loadFromCache() { return }
            showError("Offline and no saved quizzes yet. Turn off Airplane Mode and refresh once.")
            return
        }

        QuizService.fetchQuizData(from: urlString) { result in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()

                switch result {
                case .success(let data):
                    do {
                        let remote = try QuizService.decodeQuizzes(from: data)

                        // Save to disk for offline use (Part 4)
                        QuizCache.shared.save(data: data)

                        self.apply(remoteQuizzes: remote)
                    } catch {
                        // Downloaded something but it wasn't valid JSON
                        if !self.loadFromCache() {
                            self.showError("Downloaded data was invalid and no cache is available.")
                        }
                    }

                case .failure(let error):
                    if self.loadFromCache() {
                        self.showError("Could not download from URL. Using saved quizzes.\n(\(error.localizedDescription))")
                    } else {
                        self.showError("Could not download quizzes. Check your URL or connection.\n(\(error.localizedDescription))")
                    }
                }
            }
        }
    }

    private func loadFromCache() -> Bool {
        guard let data = QuizCache.shared.load() else { return false }
        do {
            let remote = try QuizService.decodeQuizzes(from: data)
            apply(remoteQuizzes: remote)
            return true
        } catch {
            return false
        }
    }

    private func apply(remoteQuizzes: [RemoteQuiz]) {
        self.quizzes = remoteQuizzes.map { rq in
            Quiz(
                title: rq.title,
                desc: rq.desc,
                iconName: iconForQuizTitle(rq.title),
                questions: rq.questions.map { q in
                    // JSON has "answer": "1" (1-based string) -> convert to 0-based Int
                    let oneBased = Int(q.answer) ?? 1
                    let zeroBased = max(0, oneBased - 1)
                    return QuizQuestion(text: q.text, answers: q.answers, correctIndex: zeroBased)
                }
            )
        }
        tableView.reloadData()
    }

    // MARK: - Helpers
    private func currentQuizURL() -> String {
        let saved = UserDefaults.standard.string(forKey: urlKey)?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (saved?.isEmpty == false) ? saved! : defaultQuizURL
    }

    private func iconForQuizTitle(_ title: String) -> String {
        let lower = title.lowercased()
        if lower.contains("math") { return "function" }
        if lower.contains("marvel") { return "bolt.fill" }
        if lower.contains("science") { return "atom" }
        return "questionmark.circle"
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
