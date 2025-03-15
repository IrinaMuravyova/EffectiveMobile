//
//  TodoListRouter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol TodoListRouterProtocol: AnyObject {
    func navigateToEditTodo(with todo: Todo, at indexPath: IndexPath)
    func navigateToCreateTodo()
}

final class TodoListRouter {
    weak var view: TodoListViewController?
    weak var interactor: TodoListInteractorProtocol?
    
}

extension TodoListRouter: TodoListRouterProtocol {
    func navigateToEditTodo(with todo: Todo, at indexPath: IndexPath) {
        
        guard let view = view else {
            print("TodoListViewController is nil")
            return
        }
       
        let editTodoViewController = EditTodoModuleConfigurator.configure(with: todo, at: indexPath)
        if let editTodoRouter = (editTodoViewController as? EditTodoViewController)?.presenter?.router {
               editTodoRouter.delegate = self
           }
        view.navigationController?.pushViewController(editTodoViewController, animated: true)
    }
    
    func navigateToCreateTodo() {
        guard let view = view else {
            print("TodoListViewController is nil")
            return
        }
       
        let createTodoViewController = CreateTodoModuleConfigurator.configure()
        if let createTodoRouter = (createTodoViewController as? CreateTodoViewController)?.presenter?.router {
            createTodoRouter.delegate = self
           }

        createTodoViewController.modalPresentationStyle = .fullScreen
        view.navigationController?.present(createTodoViewController, animated: true)
    }
}

extension TodoListRouter: EditTodoRouterDelegate {
    func didUpdateTodo() {
        interactor?.getData()
    }
    
    func didUpdateTodo(with indexPath: IndexPath, todo: Todo) {
        interactor?.updateTodoCell(at: indexPath, with: todo)
    }
}

extension TodoListRouter: CreateTodoRouterDelegate {
    func todoDidCreated() {
        interactor?.getData()
    }
}
