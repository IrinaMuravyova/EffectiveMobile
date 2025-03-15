//
//  ToDoListRouter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListRouterProtocol: AnyObject {
    func navigateToEditTodo(with todo: ToDo, at indexPath: IndexPath)
}
class ToDoListRouter {
    weak var view: ToDoListViewController?
    weak var interactor: ToDoListInteractorProtocol?
    
}

extension ToDoListRouter: ToDoListRouterProtocol {
    func navigateToEditTodo(with todo: ToDo, at indexPath: IndexPath) {
        
        guard let view = view else {
            print("ToDoListViewController is nil")
            return
        }
       
        let editTodoViewController = EditTodoModuleConfigurator.configure(with: todo, at: indexPath)
        if let editTodoRouter = (editTodoViewController as? EditTodoViewController)?.presenter?.router {
               editTodoRouter.delegate = self
           }
        view.navigationController?.pushViewController(editTodoViewController, animated: true)
    }
}

extension ToDoListRouter: EditTodoRouterDelegate {
    func didUpdateTodo() {
        interactor?.getData()
    }
    
    func didUpdateTodo(with indexPath: IndexPath, todo: ToDo) {
        interactor?.updateTodoCell(at: indexPath, with: todo)
    }
}
