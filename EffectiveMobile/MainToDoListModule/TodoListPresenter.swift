//
//  TodoListPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol TodoListPresenterProtocol: AnyObject {
    func updateSearchResult(with query: String)
    func completeButtonTapped(for id: UUID, at index: IndexPath)
    func createToDo()
    func fetchData()
    func configure(cell: TodoTableViewCell, at index: IndexPath)
    func getTodosCount() -> Int
    func getTodosCountString() -> String
    func clearSearchResult()
}

protocol TodoListPresenterOutputProtocol: AnyObject {
    func showShareActionAlert()
}

final class TodoListPresenter {
    private var todos: [Todo] = []
    private var todosBeforeFiltering: [Todo] = []
    var todosCount: Int {
            return todos.count
        }
    
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorProtocol?
    var router: TodoListRouterProtocol?
}

extension TodoListPresenter: TodoListPresenterProtocol {
    func updateSearchResult(with query: String) {
        todos = todosBeforeFiltering
        
        guard !query.isEmpty else {
            todos = todosBeforeFiltering
            viewReload()
            return
        }
            
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let filteredTodos = todos.filter { todo in
                let titleContains = todo.title.lowercased().contains(query.lowercased())
                let descriptionContains = todo.description.lowercased().contains(query.lowercased())
                let dateContains = todo.date.contains(query.lowercased())
                
                return titleContains || descriptionContains || dateContains
        }
        
            DispatchQueue.main.async { [self] in
                didFilteredToDoList(filteredTodos)
            }
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
        router?.navigateToCreateTodo()
    }

    func fetchData() {
        interactor?.fetchData()
    }
    
    func configure(cell: TodoTableViewCell, at index: IndexPath) {
        let todo = todos[index.row]
        cell.configure(
            with: todo,
            onEdit: { [weak self] in
                self?.router?.navigateToEditTodo(with: todo, at: index)
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

extension TodoListPresenter: TodoListInteractorOutputProtocol {
    func didLoadToDoList(_ todos: [Todo]) {
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
    
    func updateTodoCell(at indexPath: IndexPath, with todo: Todo) {
        updateLocalTodoProperties(with: todo)
        DispatchQueue.main.async {
            self.view?.reloadCell(with: indexPath)
        }
    }
}

// MARK: - Private methods
extension TodoListPresenter {
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
    
    private func didFilteredToDoList(_ filteredTodos: [Todo]) {
        todosBeforeFiltering = self.todos
        self.todos = filteredTodos
        viewReload()
    }
    
    private func viewReload() {
        view?.reloadTableView()
        view?.updateFooter()
    }
    
    private func updateLocalTodoProperties(with todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].title = todo.title
            todos[index].date = todo.date
            todos[index].description = todo.description
        }
    }
}
