//
//  EditTodoPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import Foundation

protocol EditTodoPresenterProtocol: AnyObject {
    var router: EditTodoRouterProtocol? { get set }
    
    func viewDidLoad()
    func viewDidPressBackButton(
        title: String,
        dateString: String,
        description: String
    )
}

class EditTodoPresenter {
    weak var view: EditTodoViewProtocol?
    var interactor: EditTodoInteractorProtocol?
    var router: EditTodoRouterProtocol?
    
    var todo: ToDo?
    var indexPath: IndexPath?
}

extension EditTodoPresenter: EditTodoPresenterProtocol {
    func viewDidLoad() {
        if let todo = todo {
            view?.displayTodo(with: todo)
        }
    }
    
    func viewDidPressBackButton(
        title: String,
        dateString: String,
        description: String
    ) {
        guard !title.isEmpty else {
            view?.showAlert(message: "Название не может быть пустым")
            return
        }
  
        guard Date.fromString(dateString) != nil else {
            view?.showAlert(message: "Некорректный формат даты. Укажите дату в формате: 03/03/25")
            return
        }
        
        guard let todo = self.todo else {
            print("Editable todo is empty")
            return
        }
        interactor?.updateTodo(for: todo, withTitle: title, dateString: dateString, description: description)
    }
}

extension EditTodoPresenter: EditTodoInteractorOutputProtocol {
    func todoDidUpdated() {
        if let indexPath = self.indexPath {
            guard let todo = self.todo else {
                print("Editable todo is empty")
                return
            }
            
            router?.dismiss(with: indexPath, todo: todo)
        } else {
            router?.dismiss()
        }
    }
    
    func setTodo(with todo: ToDo, at indexPath: IndexPath) {
        self.todo = todo
        self.indexPath = indexPath
    }
}
