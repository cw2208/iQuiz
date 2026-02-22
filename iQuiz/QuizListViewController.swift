//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Christina Wang on 2/14/26.
//
import UIKit

class QuizListViewController: UITableViewController {

    private let defaultQuizURL = "http://tednewardsandbox.site44.com/questions.json"
    private let urlKey = "quiz_url"

    private var quizzes: [Quiz] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "iQuiz"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )

        // extra credit
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)

        downloadAndReload()
    }


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


    @objc private func didTapSettings() {
        let alert = UIAlertController(title: "Settings", message: "Quiz URL:", preferredStyle: .alert)

        alert.addTextField { tf in
            tf.text = self.currentQuizURL()
            tf.placeholder = "http://..."
            tf.keyboardType = .URL
            tf.autocapitalizationType = .none
            tf.autocorrectionType = .no
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let newURL = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? self.currentQuizURL()
            self.saveQuizURL(newURL)
        })

        alert.addAction(UIAlertAction(title: "Check Now", style: .default) { _ in
            let newURL = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? self.currentQuizURL()
            self.saveQuizURL(newURL)
            self.downloadAndReload()
        })

        present(alert, animated: true)
    }


    @objc private func pulledToRefresh() {
        downloadAndReload()
    }


    private func downloadAndReload() {
        // Network not available -> notify user
        if !NetworkMonitor.shared.isConnected {
            refreshControl?.endRefreshing()
            showError("Network is not available.")
            return
        }

        let urlString = currentQuizURL()

        QuizService.fetchQuizzes(from: urlString) { result in
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()

                switch result {
                case .success(let remoteQuizzes):
                    self.quizzes = remoteQuizzes.map { rq in
                        Quiz(
                            title: rq.title,
                            desc: rq.desc,
                            iconName: self.iconForQuizTitle(rq.title),
                            questions: rq.questions.map { q in
                                let oneBased = Int(q.answer) ?? 1
                                let zeroBased = max(0, oneBased - 1)
                                return QuizQuestion(text: q.text, answers: q.answers, correctIndex: zeroBased)
                            }
                        )
                    }
                    self.tableView.reloadData()

                case .failure:
                    self.showError("Could not download quizzes. Check your URL or connection.")
                }
            }
        }
    }


    private func currentQuizURL() -> String {
        UserDefaults.standard.string(forKey: urlKey) ?? defaultQuizURL
    }

    private func saveQuizURL(_ url: String) {
        UserDefaults.standard.set(url, forKey: urlKey)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func iconForQuizTitle(_ title: String) -> String {
        let lower = title.lowercased()
        if lower.contains("math") { return "function" }
        if lower.contains("marvel") { return "bolt.fill" }
        if lower.contains("science") { return "atom" }
        return "questionmark.circle"
    }
}
