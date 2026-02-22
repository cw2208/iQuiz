import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!

    var quiz: Quiz!
    var questionIndex: Int = 0
    var score: Int = 0
    var pickedIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        let q = quiz.questions[questionIndex]
        questionLabel.text = q.text

        let correctAnswer = q.answers[q.correctIndex]
        correctLabel.text = "Correct answer: \(correctAnswer)"

        let isCorrect = (pickedIndex == q.correctIndex)
        resultLabel.text = isCorrect ? "Correct!" : "Wrong!"
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @IBAction func nextTapped(_ sender: Any) {
        let nextIndex = questionIndex + 1

        if nextIndex < quiz.questions.count {
            let storyboard = self.storyboard!
            let vc = storyboard.instantiateViewController(withIdentifier: "QuestionVC") as! QuestionViewController
            vc.quiz = quiz
            vc.questionIndex = nextIndex
            vc.score = score
            navigationController?.pushViewController(vc, animated: true)
        } else {
            performSegue(withIdentifier: "ShowFinished", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinished",
           let vc = segue.destination as? FinishedViewController {
            vc.total = quiz.questions.count
            vc.score = score
        }
    }
    @objc func handleSwipeRight() {
        nextTapped(self)
    }

    @objc func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}
