//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Christina Wang on 2/22/26.
//
import UIKit

class QuestionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    var quiz: Quiz!

    var questionIndex = 0
    var score = 0
    var selectedAnswerIndex: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        title = quiz.title
        tableView.dataSource = self
        tableView.delegate = self
        loadQuestion()
        
        showSwipeTipIfNeeded()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
    }

    private func loadQuestion() {
        selectedAnswerIndex = nil
        submitButton.isEnabled = false

        let q = quiz.questions[questionIndex]
        questionLabel.text = q.text
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quiz.questions[questionIndex].answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let answer = quiz.questions[questionIndex].answers[indexPath.row]
        cell.textLabel?.text = answer
        cell.accessoryType = (indexPath.row == selectedAnswerIndex) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        submitButton.isEnabled = true
        tableView.reloadData()
    }


    @IBAction func submitTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowAnswer", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnswer",
           let vc = segue.destination as? AnswerViewController {

            let q = quiz.questions[questionIndex]
            let picked = selectedAnswerIndex ?? -1
            let isCorrect = (picked == q.correctIndex)

            if isCorrect { score += 1 }

            vc.quiz = quiz
            vc.questionIndex = questionIndex
            vc.score = score
            vc.pickedIndex = picked
        }
    }
    @objc func handleSwipeRight() {
        if selectedAnswerIndex != nil {
            performSegue(withIdentifier: "ShowAnswer", sender: nil)
        }
    }

    @objc func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func showSwipeTipIfNeeded() {
        let hasSeenTip = UserDefaults.standard.bool(forKey: "hasSeenSwipeTip")

        if !hasSeenTip {
            let alert = UIAlertController(
                title: "Tip",
                message: "Swipe right to continue. Swipe left to abandon the quiz.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Got it", style: .default))

            present(alert, animated: true)

            UserDefaults.standard.set(true, forKey: "hasSeenSwipeTip")
        }
    }
}
