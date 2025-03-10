//
//  ToDoListRouter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListRouterProtocol: AnyObject {
    
}

class ToDoListRouter {
    weak var view: ToDoListViewProtocol?
}

extension ToDoListRouter: ToDoListRouterProtocol {
    
}
