//
//  EditTodoPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import Foundation

protocol EditTodoPresenterProtocol: AnyObject {
    func setTodo()
}

protocol EditTodoInteractorOutputProtocol: AnyObject {
    
}

class EditTodoPresenter {
    weak var view: EditTodoViewProtocol?
    var interactor: EditTodoInteractorProtocol?
    var router: EditTodoRouterProtocol?
}

extension EditTodoPresenter: EditTodoPresenterProtocol {
    func setTodo() {
        view?.displayTodo()
    }
}

extension EditTodoPresenter: EditTodoInteractorOutputProtocol {
}
