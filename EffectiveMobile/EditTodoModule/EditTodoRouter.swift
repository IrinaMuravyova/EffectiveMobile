//
//  EditTodoRouter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

protocol EditTodoRouterProtocol: AnyObject {
    var delegate: EditTodoRouterDelegate? { get set }
    func dismiss()
    func dismiss(with indexPath: IndexPath, todo: ToDo)
}

protocol EditTodoRouterDelegate: AnyObject {
    func didUpdateTodo()
    func didUpdateTodo(with indexPath: IndexPath, todo: ToDo)
}

class EditTodoRouter {
    weak var view: UIViewController?
    weak var delegate: EditTodoRouterDelegate?
}

extension EditTodoRouter: EditTodoRouterProtocol {
    func dismiss() {
        
        self.delegate?.didUpdateTodo()
        DispatchQueue.main.async {
            self.view?.navigationController?.popViewController(animated: true)
        }
    }
    
    func dismiss(with indexPath: IndexPath, todo: ToDo) {
        self.delegate?.didUpdateTodo(with: indexPath, todo: todo)
        DispatchQueue.main.async {
            self.view?.navigationController?.popViewController(animated: true)
        }
    }
}
