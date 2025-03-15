//
//  EditTodoViewController.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

protocol EditTodoViewProtocol: AnyObject {
    func displayTodo(with todo: ToDo)
    func showAlert(message: String)
}

class EditTodoViewController: UIViewController {
    private var titleTextView = BaseTodoTitle()
    private var descriptionTextView = BaseTodoDescription()
    private var dateTextView = BaseTodoDate()
    
    private let navigationBarTintColor = UIColor(hex: "#FED702")
    
    var presenter: EditTodoPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleTextView()
        setupDescriptionTextView()
        setupDateTextView()
        setupLayout()
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
    private func setupTitleTextView() {
        titleTextView.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleTextView.setLetterSpacing(0.4)
        
        titleTextView.setContentHuggingPriority(.required, for: .vertical)
        titleTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        titleTextView.isEditable = true
        titleTextView.tintColor = .white
        
        titleTextView.returnKeyType = .done
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        descriptionTextView.isEditable = true
        descriptionTextView.tintColor = .white
        
        descriptionTextView.returnKeyType = .done
    }
    
    private func setupDateTextView() {
        dateTextView.setContentHuggingPriority(.required, for: .vertical)
        dateTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        
        dateTextView.isEditable = true
        dateTextView.tintColor = .white
        
        dateTextView.keyboardType = .numbersAndPunctuation
        dateTextView.returnKeyType = .done
    }
    
    private func setupLayout() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(titleTextView)
        stackView.addArrangedSubview(dateTextView)
        stackView.addArrangedSubview(descriptionTextView)
       
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
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
    func displayTodo(with todo: ToDo) {
        titleTextView.text = todo.title
        descriptionTextView.text = todo.description
        dateTextView.text = todo.date
    }

    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}
