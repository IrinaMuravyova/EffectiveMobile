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
    func updateTodoCell(at indexPath: IndexPath, with todo: ToDo)
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadToDoList(_ todos: [ToDo])
    func setFilteredTodos()
    func todoDidDeleted(with id: UUID)
    func updateTodoCell(at indexPath: IndexPath, with todo: ToDo)
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
        self.repository?.deleteTodo(with: id) { [weak self] result in
            switch result {
            case .success(let deletedId):
                self?.presenter?.todoDidDeleted(with: deletedId)
            case .failure:
                print("Failed to delete task")
            }
                
        }
    }
    
    func markTodoCompleted(for id: UUID, with state: Bool){
        repository?.changeTodoComplete(for: id, with: state) { _ in }
    }
    
    func updateTodoCell(at indexPath: IndexPath, with todo: ToDo) {
        presenter?.updateTodoCell(at: indexPath, with: todo)
        
    }
}
