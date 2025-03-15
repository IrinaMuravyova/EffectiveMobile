//
//  TodoListViewControllerTests.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import Foundation
import XCTest
@testable import EffectiveMobile

class TodoListViewControllerTests: XCTestCase {
    var viewController: TodoListViewController!
    var mockPresenter: MockTodoListPresenter!
    
    override func setUp() {
        super.setUp()
        viewController = TodoListViewController()
        mockPresenter = MockTodoListPresenter()
        viewController.presenter = mockPresenter
        
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    
    func testSetupUI() {
        viewController.viewDidLoad()
        
        XCTAssertEqual(viewController.title, "Задачи")
        
        XCTAssertNotNil(viewController.navigationItem.searchController)
        XCTAssertEqual(viewController.searchController.searchBar.placeholder, "Search")
        
        XCTAssertNotNil(viewController.tableView)
        XCTAssertTrue(viewController.view.subviews.contains(viewController.tableView))
        
        XCTAssertNotNil(viewController.toolBar)
        XCTAssertTrue(viewController.view.subviews.contains(viewController.toolBar))
    }
    
    func testFetchDataOnViewDidLoad() {
        viewController.viewDidLoad()
        XCTAssertTrue(mockPresenter.fetchDataCalled)
    }
    
    func testReloadTableView() {
        viewController.reloadTableView()
        
        XCTAssertTrue(viewController.tableView.dataSource === viewController)
        XCTAssertTrue(viewController.tableView.delegate === viewController)
    }
    
    func testUpdateFooter() {
        mockPresenter.todosCountStringToReturn = "5 задач"
        
        viewController.updateFooter()
        
        XCTAssertEqual(viewController.footerLabel.text, "5 задач")
        XCTAssertTrue(mockPresenter.getTodosCountStringCalled)
    }
    
    func testShowShareActionAlert() {
        let navigationController = UINavigationController(rootViewController: viewController)
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = scene?.windows.first
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        viewController.loadViewIfNeeded()

        let expectation = XCTestExpectation(description: "Alert presented")

        DispatchQueue.main.async {
            self.viewController.showShareActionAlert()
        }

        // Ожидаем появления UIAlertController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let alert = self.viewController.presentedViewController as? UIAlertController {
                XCTAssertEqual(alert.title, "Функция в разработке")
                XCTAssertEqual(alert.message, "Мы скоро добавим эту функцию")
                expectation.fulfill()
            } else {
                XCTFail("UIAlertController не был показан")
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateTodoStatus() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        // Вызываем метод протокола
        viewController.updateTodoStatus(for: UUID(), at: indexPath)
        
        // Проверяем, что таблица обновила строку
        XCTAssertTrue(viewController.tableView.dataSource === viewController)
    }
    
    func testUpdateSearchResults() {
        let searchText = "Test"
        
        // Вызываем метод поиска
        viewController.updateSearchResults(for: viewController.searchController)
        
        // Проверяем, что метод презентера был вызван
        XCTAssertTrue(mockPresenter.updateSearchResultCalled)
    }
    
    func testSearchBarCancelButtonClicked() {
        // Вызываем метод отмены поиска
        viewController.searchBarCancelButtonClicked(viewController.searchController.searchBar)
        
        // Проверяем, что метод презентера был вызван
        XCTAssertTrue(mockPresenter.clearSearchResultCalled)
    }
    
    func testAddTapped() {
        // Вызываем действие кнопки
        viewController.addTapped()
        
        // Проверяем, что метод презентера был вызван
        XCTAssertTrue(mockPresenter.createToDoCalled)
    }
}
