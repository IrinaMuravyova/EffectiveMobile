//
//  BaseTodoViewController.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import UIKit

class BaseTodoViewController: UIViewController {
    var titleTextView = BaseTodoTitle()
    var descriptionTextView = BaseTodoDescription()
    var dateTextView = BaseTodoDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleTextView()
        setupDescriptionTextView()
        setupDateTextView()
        setupLayout()
    }
}

// MARK: - Private methods
extension BaseTodoViewController {
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
}
