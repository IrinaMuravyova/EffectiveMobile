//
//  TodoListModuleConfiguratorTests.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class TodoListModuleConfiguratorTests: XCTestCase {
    func testConfigure() {
        // Вызов метода
        let viewController = TodoListModuleConfigurator.configure()
        
        // Проверка, что возвращается правильный тип
        XCTAssertTrue(viewController is TodoListViewController)
        
        // Приведение к типу TodoListViewController
        guard let todoListViewController = viewController as? TodoListViewController else {
            XCTFail("Expected TodoListViewController")
            return
        }
        
        // Проверка, что presenter установлен
        XCTAssertNotNil(todoListViewController.presenter)
        
        // Проверка, что presenter имеет правильные зависимости
        guard let presenter = todoListViewController.presenter as? TodoListPresenter else {
            XCTFail("Expected TodoListPresenter")
            return
        }
        
        XCTAssertNotNil(presenter.view)
        XCTAssertNotNil(presenter.interactor)
        XCTAssertNotNil(presenter.router)
        
        // Проверка, что interactor имеет правильные зависимости
        guard let interactor = presenter.interactor as? TodoListInteractor else {
            XCTFail("Expected TodoListInteractor")
            return
        }
        
        XCTAssertNotNil(interactor.presenter)
        XCTAssertNotNil(interactor.repository)
        
        // Проверка, что router имеет правильные зависимости
        guard let router = presenter.router as? TodoListRouter else {
            XCTFail("Expected TodoListRouter")
            return
        }
        
        XCTAssertNotNil(router.view)
        XCTAssertNotNil(router.interactor)
    }
}
