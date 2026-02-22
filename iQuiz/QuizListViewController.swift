//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Christina Wang on 2/14/26.
//
import UIKit

class QuizListViewController: UITableViewController {

    let quizzes: [Quiz] = [
        Quiz(
            title: "Mathematics",
            desc: "Test your math skills.",
            iconName: "function",
            questions: [
                QuizQuestion(text: "2 + 2 = ?", answers: ["3", "4", "5"], correctIndex: 1),
                QuizQuestion(text: "10 / 2 = ?", answers: ["3", "5", "8"], correctIndex: 1)
            ]
        ),
        Quiz(
            title: "Marvel Super Heroes",
            desc: "How well do you know Marvel?",
            iconName: "bolt.fill",
            questions: [
                QuizQuestion(text: "Spider-Man is from:", answers: ["DC", "Marvel"], correctIndex: 1),
                QuizQuestion(text: "Iron Man’s real name is:", answers: ["Tony Stark", "Bruce Wayne"], correctIndex: 0)
            ]
        ),
        Quiz(
            title: "Science",
            desc: "Explore basic science trivia.",
            iconName: "atom",
            questions: [
                QuizQuestion(text: "Water freezes at:", answers: ["0°C", "100°C"], correctIndex: 0),
                QuizQuestion(text: "Earth is the ___ planet from the sun:", answers: ["2nd", "3rd", "4th"], correctIndex: 1)
            ]
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iQuiz"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(didTapSettings)
        )
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
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
