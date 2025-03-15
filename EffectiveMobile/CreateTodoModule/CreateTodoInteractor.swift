//
//  CreateTodoInteractor.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import Foundation

protocol CreateTodoInteractorProtocol: AnyObject {
    func createTodo(title: String, date: String, description: String)
}

protocol CreateTodoInteractorOutputProtocol: AnyObject {
    func todoDidCreated()
}

final class CreateTodoInteractor {
    weak var presenter: CreateTodoInteractorOutputProtocol?
    var repository: RepositoryProtocol?
}

extension CreateTodoInteractor: CreateTodoInteractorProtocol {
    func createTodo(title: String, date: String, description: String) {
        repository?.createTodo(title: title, date: date, description: description) { result in
            switch result {
            case .success:
                self.presenter?.todoDidCreated()
            case .failure(let error):
                print("Ошибка при создании задачи: \(error.localizedDescription)")
            }
        }
    }
}

