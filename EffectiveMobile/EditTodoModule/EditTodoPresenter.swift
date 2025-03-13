//
//  EditTodoPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import Foundation

protocol EditTodoPresenterProtocol: AnyObject {
    func setTodo(with todo: ToDo)
    func viewDidLoad() 
}

protocol EditTodoInteractorOutputProtocol: AnyObject {
    
}

class EditTodoPresenter {
    weak var view: EditTodoViewProtocol?
    var interactor: EditTodoInteractorProtocol?
    var router: EditTodoRouterProtocol?
    
    var todo: ToDo?
    
    
}

extension EditTodoPresenter: EditTodoPresenterProtocol {
    func setTodo(with todo: ToDo) {
        self.todo = todo
    }
    
    func viewDidLoad() {
        if let todo = todo {
            view?.displayTodo(with: todo)
        }
    }
}

extension EditTodoPresenter: EditTodoInteractorOutputProtocol {
}
