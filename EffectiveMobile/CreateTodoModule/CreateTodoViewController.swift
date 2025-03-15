//
//  CreateTodoViewController.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import UIKit

protocol CreateTodoViewProtocol: AnyObject {
    func showAlertFor(message: String)
    func closeScreen()
}

final class CreateTodoViewController: BaseTodoViewController {
    private let buttonTextColor = UIColor(hex: "#FED702")
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    
    var presenter:  CreateTodoPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFields()
        setupButtons()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextView.becomeFirstResponder()
        
    }
    
    @objc private func okButtonTapped() {
        presenter?.createTodo(
            title: titleTextView.text,
            date: dateTextView.text,
            description: descriptionTextView.text
        )
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
}

// MARK: - Private methods
extension  CreateTodoViewController {
    private func setupFields() {
        titleTextView.placeholder = "Введите заголовок задачи"
        dateTextView.placeholder = "Укажите дату"
        descriptionTextView.placeholder = "Описание задачи"
    }
    
    private func setupButtons() {
        okButton = setButton(withTitle: "OK", color: buttonTextColor, action: #selector(okButtonTapped))
        cancelButton = setButton(withTitle: "Cancel",  color: .red, action: #selector(cancelButtonTapped))
    }
    
    private func setButton(withTitle: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(withTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupLayout() {
        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, okButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 16
        
        view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension  CreateTodoViewController:  CreateTodoViewProtocol {
    func showAlertFor(message: String) {
        self.showAlert(message: message)
    }
    
    func closeScreen() {
        self.dismiss(animated: true)
    }
}
