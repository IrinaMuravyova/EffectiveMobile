//
//  ToDoListRouter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListRouterProtocol: AnyObject {
    func navigateToEditTodo(with todo: ToDo)
}

class ToDoListRouter {
    weak var view: ToDoListViewController?
}

extension ToDoListRouter: ToDoListRouterProtocol {
    func navigateToEditTodo(with todo: ToDo) {
        
        guard let view = view else {
            print("ToDoListViewController is nil")
            return
        }
       
        let editTodoViewController = EditTodoModuleConfigurator.configure(with: todo)
        view.navigationController?.pushViewController(editTodoViewController, animated: true)
    }
}
