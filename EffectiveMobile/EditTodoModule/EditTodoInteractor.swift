//
//  EditTodoInteractor.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import Foundation

protocol EditTodoInteractorProtocol: AnyObject {
    func updateTodo(for todo: Todo, withTitle: String, dateString: String, description: String)
}

protocol EditTodoInteractorOutputProtocol: AnyObject {
    func todoDidUpdated()
}

final class EditTodoInteractor {
    weak var presenter: EditTodoInteractorOutputProtocol?
    var repository: RepositoryProtocol?
}

extension EditTodoInteractor: EditTodoInteractorProtocol {
    func updateTodo(for todo: Todo, withTitle: String, dateString: String, description: String) {
        repository?.updateTodo(for: todo, withTitle: withTitle, date: dateString, description: description) { result in
            switch result {
            case .success:
                self.presenter?.todoDidUpdated()
            case .failure(let error):
                print("Error updating the task: \(error.localizedDescription)")
            }
            
        }
    }
}

