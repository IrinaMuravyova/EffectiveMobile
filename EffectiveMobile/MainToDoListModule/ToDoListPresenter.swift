//
//  ToDoListPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    func updateSearchResult(with query: String)
    func markToDoIsCompleted()
    func createToDo()
    func getData()
    func configure(cell: ToDoTableViewCell, at index: Int)
    func getTodosCount() -> Int 
    func getTodosCountString() -> String
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadToDoList(_ todos: [ToDo])
    func setFilteredTodos()
}

class ToDoListPresenter {
    private var todos: [ToDo] = []
    private var todosBeforeFiltering: [ToDo] = []
    var todosCount: Int {
            return todos.count
        }
    
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol?
    var router: ToDoListRouterProtocol?
}

extension ToDoListPresenter: ToDoListPresenterProtocol {
    func updateSearchResult(with query: String) {
        todos = todosBeforeFiltering
        
        if query.isEmpty {
                todos = todosBeforeFiltering
        } else {
            let filteredTodos = todos.filter { todo in
                print("Filtering started")
                let titleContains = todo.title.lowercased().contains(query.lowercased())
                print("titleContains:  ", titleContains)
                let descriptionContains = todo.description.lowercased().contains(query.lowercased())
                print("descriptionContains:  ", descriptionContains)
                let dateContains = todo.date.contains(query.lowercased())
                print("dateContains:  ", dateContains)
                
                return titleContains || descriptionContains || dateContains
            }
            didFilteredToDoList(filteredTodos)
        }
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
        viewReload()
    }
    
    func setFilteredTodos() {
        todosBeforeFiltering = self.todos
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
    
    private func didFilteredToDoList(_ filteredTodos: [ToDo]) {
        todosBeforeFiltering = self.todos
        self.todos = filteredTodos
        viewReload()
    }
    
    private func viewReload() {
        view?.reloadTableView()
        view?.updateFooter()
    }
}
