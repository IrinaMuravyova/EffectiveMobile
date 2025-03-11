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
    func pluralizeTask(count: Int) -> String 
    func getData()
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func didLoadToDoList(_ todos: [ToDo])
}

class ToDoListPresenter {
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol?
    var router: ToDoListRouterProtocol?
    
    var todos: [ToDo] = []
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
    
    func pluralizeTask(count: Int) -> String {
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
    
    func getData() {
        interactor?.getData()
    }
}

extension ToDoListPresenter: ToDoListInteractorOutputProtocol {
    func didLoadToDoList(_ todos: [ToDo]) {
        self.todos = todos
        view?.display(todos)
        let todosCountString = pluralizeTask(count: todos.count)
        view?.display(todosCountString)
    }
}
