//
//  EditTodoInteractor.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import Foundation

protocol EditTodoInteractorProtocol: AnyObject {
    func setTodo(with todo: ToDo)
}

protocol EditTodoRepositoryOutputProtocol: AnyObject {

}

class EditTodoInteractor {
    weak var presenter: EditTodoPresenterProtocol?
    var repository: RepositoryProtocol?
}

extension EditTodoInteractor: EditTodoInteractorProtocol {
    func setTodo(with todo: ToDo) {
        presenter?.setTodo(with: todo)
    }
}

extension EditTodoInteractor: EditTodoRepositoryOutputProtocol {

}
