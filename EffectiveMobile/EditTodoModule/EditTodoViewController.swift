//
//  EditTodoViewController.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

protocol EditTodoViewProtocol: AnyObject {
    func displayTodo(with todo: ToDo)
}

class EditTodoViewController: UIViewController {
    private var titleTextView = BaseTodoTitle()
    private var descriptionTextView = BaseTodoDescription()
    private var dateTextView = BaseTodoDate()
    
    var presenter: EditTodoPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleTextView()
        setupDescriptionTextView()
        setupDateTextView()
        setupLayout()
        
        navigationItem.largeTitleDisplayMode = .never
        presenter?.viewDidLoad()
    }
}

// MARK: - Private methods
extension EditTodoViewController {
    private func setupTitleTextView() {
        titleTextView.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleTextView.setLetterSpacing(0.4)
        
        titleTextView.setContentHuggingPriority(.required, for: .vertical)
        titleTextView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func setupDateTextView() {
        dateTextView.setContentHuggingPriority(.required, for: .vertical)
        dateTextView.setContentCompressionResistancePriority(.required, for: .vertical)
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
}

extension EditTodoViewController: EditTodoViewProtocol {
    func displayTodo(with todo: ToDo) {
        titleTextView.text = todo.title
        descriptionTextView.text = todo.description
        dateTextView.text = todo.date
    }
}
