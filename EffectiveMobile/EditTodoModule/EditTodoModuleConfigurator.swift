//
//  EditTodoModuleConfigurator.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import UIKit

final class EditTodoModuleConfigurator {
    static func configure(with todo: ToDo) -> UIViewController {
        let view = EditTodoViewController()
        let presenter = EditTodoPresenter()
        let interactor = EditTodoInteractor()
        let router = EditTodoRouter()
        
        let networkManager = NetworkManager()
        let coreDataManager = CoreDataManager.shared
        let repository = Repository(networkManager: networkManager, dataManager: coreDataManager)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.repository = repository
        router.view = view
        
        interactor.setTodo(with: todo)
        
        return view
    }
}
