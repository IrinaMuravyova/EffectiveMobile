//
//  TodoListRouterTests.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class TodoListRouterTests: XCTestCase {
    var router: TodoListRouter!
    var mockViewController: MockTodoListViewController!
    var mockInteractor: MockTodoListInteractor!
    
    override func setUp() {
        super.setUp()
        router = TodoListRouter()
        mockViewController = MockTodoListViewController()
        mockInteractor = MockTodoListInteractor()
        
        mockViewController.mockNavigationController = MockNavigationController()
        
        router.view = mockViewController
        router.interactor = mockInteractor
    }
    
    override func tearDown() {
        router = nil
        mockViewController = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testNavigateToEditTodo() {
        let todo = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
            let indexPath = IndexPath(row: 0, section: 0)
            
            mockViewController.mockNavigationController = MockNavigationController()
            
            router.navigateToEditTodo(with: todo, at: indexPath)
            
            XCTAssertTrue(mockViewController.mockNavigationController.pushViewControllerCalled)
    }
    
    func testNavigateToCreateTodo() {
        mockViewController.mockNavigationController = MockNavigationController()
           
       let expectation = XCTestExpectation(description: "Present completed")
       
       router.navigateToCreateTodo()
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           XCTAssertTrue(self.mockViewController.mockNavigationController.presentViewControllerCalled)
           expectation.fulfill()
       }
       
       wait(for: [expectation], timeout: 2)
    }
    
    func testDidUpdateTodo() {
        router.didUpdateTodo()
        XCTAssertTrue(mockInteractor.getDataCalled)
    }
    
    func testDidUpdateTodoWithIndexPath() {
        let todo = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        let indexPath = IndexPath(row: 0, section: 0)
        
        router.didUpdateTodo(with: indexPath, todo: todo)
        
        XCTAssertTrue(mockInteractor.updateTodoCellCalled)
    }
    
    func testTodoDidCreated() {
        router.todoDidCreated()
        XCTAssertTrue(mockInteractor.getDataCalled)
    }
}
