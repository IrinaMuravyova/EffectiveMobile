//
//  CreateTodoRouter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import UIKit

protocol CreateTodoRouterProtocol: AnyObject {
    var delegate: CreateTodoRouterDelegate? { get set }
}

protocol CreateTodoRouterDelegate: AnyObject {
    func todoDidCreated()
}

final class CreateTodoRouter {
    weak var view: UIViewController?
    weak var delegate: CreateTodoRouterDelegate?
}

extension CreateTodoRouter: CreateTodoRouterProtocol {
    func todoDidCreated() {
        self.delegate?.todoDidCreated()
    }
}
