//
//  TodoTableViewCell.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import UIKit

protocol TodoTableViewCellProtocol: AnyObject {
    func configure(with todo: Todo, onEdit: @escaping () -> Void, onShare: @escaping () -> Void, onDelete: @escaping () -> Void, onMarkCompleted: @escaping () -> Void)
    func isCompletedConfigure(with todo: Todo)
    func isNotCompletedConfigure(with todo: Todo)
}

final class TodoTableViewCell: UITableViewCell {
    private let isCompletedIconColor = UIColor(hex: "#FED702")
    private let isNotCompletedIconColor = UIColor(hex: "#4D555E")
    private let isCompletedImage = UIImage(systemName: "checkmark.circle")
    private let isNotCompletedImage = UIImage(systemName: "circle")
    private let textColor = UIColor(hex: "#F4F4F4")
    private let contextMenuButtonBackgroundColor =  UIColor(hex: "#EDEDEDCC")
    private let iconSize = 24
    
    private var isCompletedButton: UIButton!
    private var titleTextView = BaseTodoTitle()
    private var descriptionTextView = BaseTodoDescription()
    private var dateTextView = BaseTodoDate()
    
    private var onEdit: (() -> Void)?
    private var onShare: (() -> Void)?
    private var onDelete: (() -> Void)?
    private var onMarkCompleted: (() -> Void)?
    
    var presenter: TodoListPresenterProtocol?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupIsCompletedButton()
        setupLayout()
        
        let menu = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(menu)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        onMarkCompleted?()
    }
}

extension TodoTableViewCell: TodoTableViewCellProtocol {
    func configure(
        with todo: Todo,
        onEdit: @escaping () -> Void,
        onShare: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        onMarkCompleted: @escaping () -> Void
    ) {
        self.onEdit = onEdit
        self.onShare = onShare
        self.onDelete = onDelete
        self.onMarkCompleted = onMarkCompleted
        
        descriptionTextView.text = todo.description
        if let date = Date.fromString(todo.date) {
            let formattedDate = date.formattedString()
            dateTextView.text = formattedDate
        }
    }
    
    func isNotCompletedConfigure(with todo: Todo) {
        isCompletedButton.setImage(isNotCompletedImage, for: .normal)
        isCompletedButton.tintColor = isNotCompletedIconColor
       
        titleTextView.alpha = 1
        let attributedString = NSAttributedString(
            string: todo.title,
            attributes: [.font: UIFont.systemFont(ofSize: 16),
                         .foregroundColor: textColor]
        )
        titleTextView.attributedText = attributedString
        
        descriptionTextView.alpha = 1
    }
    
    func isCompletedConfigure(with todo: Todo) {
        isCompletedButton.setImage(isCompletedImage, for: .normal)
        isCompletedButton.tintColor = isCompletedIconColor
        
        titleTextView.alpha = 0.5
        let attributedString = NSAttributedString(
            string: todo.title,
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                         .font: UIFont.systemFont(ofSize: 16),
                         .foregroundColor: textColor,
                         .strikethroughColor: textColor]
        )
        titleTextView.attributedText = attributedString
        
        descriptionTextView.alpha = 0.5
    }
}

// MARK: - Private methods
extension TodoTableViewCell {
    private func setupIsCompletedButton() {
        isCompletedButton = UIButton()
        
        isCompletedButton.configuration = .plain()
        isCompletedButton.translatesAutoresizingMaskIntoConstraints = false
        isCompletedButton.isEnabled = true
    
        isCompletedButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        contentView.addSubview(isCompletedButton)
    }
    
    private func setupLayout() {
        
        let subStackView = UIStackView()
        subStackView.translatesAutoresizingMaskIntoConstraints = false
        subStackView.axis = .vertical
        subStackView.spacing = 6
        subStackView.alignment = .leading
        subStackView.distribution = .fill
        
        subStackView.addArrangedSubview(titleTextView)
        subStackView.addArrangedSubview(descriptionTextView)
        subStackView.addArrangedSubview(dateTextView)

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        
        stackView.addArrangedSubview(isCompletedButton)
        stackView.addArrangedSubview(subStackView)
       
        contentView.addSubview(stackView)

        let imageSize = CGSize(width: iconSize, height: iconSize)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant:12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            isCompletedButton.widthAnchor.constraint(equalToConstant: imageSize.width),
            isCompletedButton.heightAnchor.constraint(equalToConstant: imageSize.height),
        ])
    }
}

extension TodoTableViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
             
                let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                    self.onEdit?()
                }
                
                let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [self] _ in
                    self.onShare?()
                }
                
                let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.onDelete?()
                }
                
                return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
            }
    }
}
