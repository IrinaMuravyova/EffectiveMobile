//
//  ToDoListPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    func updateSearchResult(with: String)
    func markToDoIsCompleted()
    func createToDo()
    func getData()
    func configure(cell: ToDoTableViewCell, at index: Int)
    func getTodosCount() -> Int 
    func getTodosCountString() -> String
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadToDoList(_ todos: [ToDo])
}

class ToDoListPresenter {
    private var todos: [ToDo] = []
    var todosCount: Int {
            return todos.count
        }
    
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol?
    var router: ToDoListRouterProtocol?
}

extension ToDoListPresenter: ToDoListPresenterProtocol {
    func updateSearchResult(with: String) {
        // TODO: add filtering logic
    }
    
    func markToDoIsCompleted() {
        // TODO: add todo's mark logic
    }
    
    func createToDo() {
        // TODO: add create todo logic
    }

    func getData() {
        interactor?.getData()
    }
    
    func configure(cell: ToDoTableViewCell, at index: Int) {
        let todo = todos[index]
        cell.configure(with: todo)
        
        if todo.isCompleted {
            cell.isCompletedConfigure(with: todo)
        } else {
            cell.isNotCompletedConfigure(with: todo)
        }
    }
    
    func getTodosCount() -> Int {
        todosCount
    }
    
    func getTodosCountString() -> String {
        pluralizeTask(count: todosCount)
    }
}

extension ToDoListPresenter: ToDoListInteractorOutputProtocol {
    func didLoadToDoList(_ todos: [ToDo]) {
        self.todos = todos
        view?.reloadTableView()
        view?.updateFooter()
    }
}

// MARK: - Private methods
extension ToDoListPresenter {
    private func pluralizeTask(count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100

        let word: String
        if remainder10 == 1 && remainder100 != 11 {
            word = "Задача"
        } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
            word = "Задачи"
        } else {
            word = "Задач"
        }

        return "\(count) \(word)"
    }
}
