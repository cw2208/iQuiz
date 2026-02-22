import UIKit

class FinishedViewController: UIViewController {

    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    var score: Int = 0
    var total: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = "\(score) of \(total) correct"

        if score == total {
            summaryLabel.text = "Perfect!"
        } else if score >= max(1, total - 1) {
            summaryLabel.text = "Almost!"
        } else {
            summaryLabel.text = "Keep trying!"
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
            swipeRight.direction = .right
            view.addGestureRecognizer(swipeRight)

            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
            swipeLeft.direction = .left
            view.addGestureRecognizer(swipeLeft)
    }

    @IBAction func nextTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleSwipeRight() {
        nextTapped(self)
    }

    @objc func handleSwipeLeft() {
        navigationController?.popToRootViewController(animated: true)
    }
}
