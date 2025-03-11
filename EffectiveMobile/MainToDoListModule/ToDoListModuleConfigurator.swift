//
//  ToDoListModuleConfigurator.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import UIKit

final class ToDoListModuleConfigurator {
    static func configure() -> UIViewController {
        let view = ToDoListViewController()
        let presenter = ToDoListPresenter()
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()
        
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
        
        return view
    }
}
