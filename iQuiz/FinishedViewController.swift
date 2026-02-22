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
    }

    @IBAction func nextTapped(_ sender: Any) {
        // easiest: pop back to root list
        navigationController?.popToRootViewController(animated: true)
    }
}
