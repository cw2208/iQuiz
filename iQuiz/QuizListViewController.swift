//
//  QuizListViewController.swift
//  iQuiz
//
//  Created by Christina Wang on 2/14/26.
//
import UIKit

struct QuizTopic {
    let title: String
    let desc: String
    let iconName: String
}

class QuizListViewController: UITableViewController {

    let quizTopics: [QuizTopic] = [
        QuizTopic(title: "Mathematics", desc: "Test your math skills.", iconName: "function"),
        QuizTopic(title: "Marvel Super Heroes", desc: "How well do you know Marvel?", iconName: "bolt.fill"),
        QuizTopic(title: "Science", desc: "Explore basic science trivia.", iconName: "atom")
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
        return quizTopics.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TopicCell")

        let topic = quizTopics[indexPath.row]
        cell.textLabel?.text = topic.title
        cell.detailTextLabel?.text = topic.desc
        cell.imageView?.image = UIImage(systemName: topic.iconName)

        cell.accessoryType = .disclosureIndicator
        return cell
    }

    @objc private func didTapSettings() {
        let alert = UIAlertController(title: "Settings",
                                      message: "Settings go here",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

