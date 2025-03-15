//
//  CreateTodoModuleConfigurator.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import UIKit

final class CreateTodoModuleConfigurator {
    static func configure() -> UIViewController {
        let view = CreateTodoViewController()
        let presenter = CreateTodoPresenter()
        let interactor = CreateTodoInteractor()
        let router = CreateTodoRouter()
        
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
