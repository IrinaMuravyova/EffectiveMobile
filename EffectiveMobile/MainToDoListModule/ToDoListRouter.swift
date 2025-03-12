//
//  ToDoListRouter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListRouterProtocol: AnyObject {
    func navigateToEditTodo(with: UUID)
}

class ToDoListRouter {
    weak var view: ToDoListViewProtocol?
}

extension ToDoListRouter: ToDoListRouterProtocol {
    func navigateToEditTodo(with: UUID) {
       //TODO: add code
    }
}
