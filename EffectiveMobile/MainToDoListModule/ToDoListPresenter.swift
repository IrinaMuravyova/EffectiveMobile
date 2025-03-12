//
//  ToDoListPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    func updateSearchResult(with query: String)
    func completeButtonTapped(for id: UUID, at index: IndexPath)
    func createToDo()
    func fetchData()
    func configure(cell: ToDoTableViewCell, at index: IndexPath)
    func getTodosCount() -> Int
    func getTodosCountString() -> String
    func clearSearchResult()
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadToDoList(_ todos: [ToDo])
    func setFilteredTodos()
    func todoDidDeleted(with id: UUID)
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
                let titleContains = todo.title.lowercased().contains(query.lowercased())
                let descriptionContains = todo.description.lowercased().contains(query.lowercased())
                let dateContains = todo.date.contains(query.lowercased())
                
                return titleContains || descriptionContains || dateContains
            }
            didFilteredToDoList(filteredTodos)
        }
    }
    
    func completeButtonTapped(for id: UUID, at index: IndexPath) {
        
        if let todoIndex = todos.firstIndex(where: { $0.id == id }) {
            todos[todoIndex].isCompleted.toggle()
            interactor?.markTodoCompleted(for: id, with: todos[todoIndex].isCompleted)
        }
        view?.updateTodoStatus(for: id, at: index)
    }
    
    func createToDo() {
        // TODO: add create todo logic
    }

    func fetchData() {
        interactor?.fetchData()
    }
    
    func configure(cell: ToDoTableViewCell, at index: IndexPath) {
        let todo = todos[index.row]
        cell.configure(
            with: todo,
            onEdit: { [weak self] in
                self?.router?.navigateToEditTodo(with: todo.id)
            },
            onShare: { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    self?.view?.showShareActionAlert()
                }
            },
            onDelete: { [weak self] in
                self?.interactor?.deleteTodo(with: todo.id)
                self?.todoDidDeleted(with: todo.id)
            },
            onMarkCompleted: { [weak self] in
                self?.completeButtonTapped(for: todo.id, at: index)
            }
        )
        
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
    
    func clearSearchResult() {
        todos = todosBeforeFiltering
        didFilteredToDoList(todos)
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
    
    func todoDidDeleted(with id: UUID) {
        todos.removeAll { $0.id == id }
        viewReload()
        interactor?.getData()
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
