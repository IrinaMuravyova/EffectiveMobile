//
//  ToDoListInteractor.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    func fetchData()
    func getData()
    func deleteTodo(with id: UUID)
    func markTodoCompleted(for id: UUID, with state: Bool)
}

protocol ToDoListRepositoryOutputProtocol: AnyObject {
    func todoDidDeleted(with id: UUID)
}

class ToDoListInteractor {
    weak var presenter: ToDoListInteractorOutputProtocol?
    var repository: RepositoryProtocol?
}

extension ToDoListInteractor: ToDoListInteractorProtocol {
    func fetchData() {
        DispatchQueue.global(qos: .background).async {
            self.repository?.fetchToDos { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let todos):
                        self.presenter?.didLoadToDoList(todos)
                        self.presenter?.setFilteredTodos()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }

    func getData() {
        DispatchQueue.global(qos: .background).async {
            self.repository?.getToDos { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let todos):
                        self?.presenter?.didLoadToDoList(todos)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func deleteTodo(with id: UUID) {
        self.repository?.deleteTodo(with: id)
        self.todoDidDeleted(with: id)
    }
    
    func markTodoCompleted(for id: UUID, with state: Bool){
        repository?.changeTodoComplete(for: id, with: state)
    }
}

extension ToDoListInteractor: ToDoListRepositoryOutputProtocol {
    func todoDidDeleted(with id: UUID) {
        presenter?.todoDidDeleted(with: id)
    }
}
