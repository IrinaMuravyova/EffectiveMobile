//
//  EditTodoViewController.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

protocol EditTodoViewProtocol: AnyObject {
    func displayTodo(with todo: Todo)
    func showAlertFor(message: String)
}

final class EditTodoViewController: BaseTodoViewController {
    
    private let navigationBarTintColor = UIColor(hex: "#FED702")
    
    var presenter: EditTodoPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        disableSwipeBackGesture()
        
        navigationItem.largeTitleDisplayMode = .never
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        descriptionTextView.becomeFirstResponder()
    }
    
    @objc private func backButtonTapped() {
        presenter?.viewDidPressBackButton(
            title: titleTextView.text ?? "",
            dateString: dateTextView.text ?? "",
            description: descriptionTextView.text ?? ""
        )
    }
}

// MARK: - Private methods
extension EditTodoViewController {
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            title: "< Назад",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = navigationBarTintColor
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func disableSwipeBackGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

extension EditTodoViewController: EditTodoViewProtocol {
    func displayTodo(with todo: Todo) {
        titleTextView.text = todo.title
        descriptionTextView.text = todo.description
        dateTextView.text = todo.date
    }

    func showAlertFor( message: String) {
        self.showAlert(message: message)
    }
}
