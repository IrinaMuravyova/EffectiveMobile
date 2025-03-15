//
//  TodoListModuleConfigurator.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import UIKit

final class TodoListModuleConfigurator {
    static func configure() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
        let networkManager = NetworkManager()
        let coreDataManager = CoreDataManager.shared
        let repository = Repository(networkManager: networkManager, dataManager: coreDataManager)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.repository = repository
        router.interactor = interactor
        router.view = view
        
        let editTodoRouter = EditTodoRouter()
        editTodoRouter.delegate = router
        
        let createTodoRouter = CreateTodoRouter()
        createTodoRouter.delegate = router
        
        return view
    }
}
