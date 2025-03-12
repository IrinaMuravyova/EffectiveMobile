//
//  ToDoTableViewCell.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import UIKit

protocol ToDoTableViewCellProtocol: AnyObject {
    func configure(with todo: ToDo)
    func isCompletedConfigure(with todo: ToDo)
    func isNotCompletedConfigure(with todo: ToDo)
}

protocol ToDoListPresenterOutputProtocol: AnyObject {
    func showShareActionAlert()
}

class ToDoTableViewCell: UITableViewCell {
    private let isCompletedIconColor = UIColor(hex: "#FED702")
    private let isNotCompletedIconColor = UIColor(hex: "#4D555E")
    private let isCompletedImage = UIImage(systemName: "checkmark.circle")
    private let isNotCompletedImage = UIImage(systemName: "circle")
    private let textColor = UIColor(hex: "#F4F4F4")
    private let contextMenuButtonBackgroundColor =  UIColor(hex: "#EDEDEDCC")
    private let iconSize = 24
    
    private var isCompletedButton: UIButton!
    private var titleTextView: UITextView!
    private var descriptionTextView: UITextView!
    private var dateTextView: UITextView!
    
    var presenter: ToDoListPresenterProtocol?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupIsCompletedButton()
        setupTitleTextView()
        setupDescriptionTextView()
        setupDateTextField()
        
        setupLayout()
        
        let menu = UIContextMenuInteraction(delegate: self)
        contentView.addInteraction(menu)
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        isCompletedButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        presenter?.markToDoIsCompleted()
    }
}

extension ToDoTableViewCell: ToDoTableViewCellProtocol {
    func configure(with todo: ToDo) {
        descriptionTextView.text = todo.description
        if let date = Date.fromString(todo.date) {
            let formattedDate = date.formattedString()
            dateTextView.text = formattedDate
        }
    }
    
    func isNotCompletedConfigure(with todo: ToDo) {
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
    
    func isCompletedConfigure(with todo: ToDo) {
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
extension ToDoTableViewCell {
    private func setupIsCompletedButton() {
        isCompletedButton = UIButton()
        
        isCompletedButton.configuration = .plain()
        isCompletedButton.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.addSubview(isCompletedButton)
    }
    
    private func setupTitleTextView(){
        titleTextView = UITextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextView.isEditable = false
        titleTextView.isScrollEnabled = false
        titleTextView.setLetterSpacing(-0.43)
        
        titleTextView.textContainerInset = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        contentView.addSubview(titleTextView)
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView = UITextView()
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 12)
        descriptionTextView.textColor = textColor
        
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView.addSubview(descriptionTextView)
    }
    
    private func setupDateTextField () {
        dateTextView = UITextView()
        dateTextView.translatesAutoresizingMaskIntoConstraints = false
        dateTextView.isEditable = false
        dateTextView.isScrollEnabled = false

        dateTextView.font = UIFont.systemFont(ofSize: 12)
        dateTextView.textColor = textColor
        dateTextView.alpha = 0.5
        
        dateTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contentView.addSubview(dateTextView)
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

extension ToDoTableViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                    //TODO: add logic
                }
                
                let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [self] _ in
                    presenter?.shareActionTapped()
                }
                
                let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    //TODO: add logic
                }
                
                return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
            }
    }
}
