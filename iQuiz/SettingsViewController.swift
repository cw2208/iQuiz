//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Christina Wang on 2/22/26.
//
import UIKit

final class SettingsViewController: UIViewController {
    var onCheckNow: (() -> Void)?

    private let urlField = UITextField()
    private let checkButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground

        urlField.borderStyle = .roundedRect
        urlField.autocapitalizationType = .none
        urlField.autocorrectionType = .no
        urlField.placeholder = "Quiz JSON URL"
        urlField.text = SettingsStore.shared.quizSourceURLString

        checkButton.setTitle("Check Now", for: .normal)
        checkButton.addTarget(self, action: #selector(didTapCheckNow), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [urlField, checkButton])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    @objc private func didTapCheckNow() {
        SettingsStore.shared.quizSourceURLString = urlField.text ?? ""

        onCheckNow?()
        
        navigationController?.popViewController(animated: true)
    }
}
