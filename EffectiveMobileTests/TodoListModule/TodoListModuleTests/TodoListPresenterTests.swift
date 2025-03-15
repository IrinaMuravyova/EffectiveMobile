//
//  TodoListPresenterTests.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class TodoListPresenterTests: XCTestCase {
    var presenter: TodoListPresenter!
    var mockView: MockTodoListView!
    var mockInteractor: MockTodoListInteractor!
    var mockRouter: MockTodoListRouter!
    
    override func setUp() {
        super.setUp()
        presenter = TodoListPresenter()
        mockView = MockTodoListView()
        mockInteractor = MockTodoListInteractor()
        mockRouter = MockTodoListRouter()
        
        presenter.view = mockView
        presenter.interactor = mockInteractor
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testUpdateSearchResult() {
        let todo1 = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        let todo2 = Todo(id: UUID(), title: "Task 2", description: "Description 2", date: "2025-03-16", isCompleted: false)
        presenter.todos = [todo1, todo2]
        presenter.todosBeforeFiltering = [todo1, todo2]
        
        let expectation = XCTestExpectation(description: "Filtering completed")
        
        presenter.updateSearchResult(with: "Task 1")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.presenter.todos.count, 1)
            XCTAssertEqual(self.presenter.todos.first?.title, "Task 1")
            XCTAssertTrue(self.mockView.reloadTableViewCalled)
            XCTAssertTrue(self.mockView.updateFooterCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testCompleteButtonTapped() {
        let todo = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        presenter.todos = [todo]
        let indexPath = IndexPath(row: 0, section: 0)
        
        presenter.completeButtonTapped(for: todo.id, at: indexPath)
        
        XCTAssertTrue(todo.isCompleted)
        XCTAssertTrue(mockInteractor.markTodoCompletedCalled)
        XCTAssertTrue(mockView.updateTodoStatusCalled)
    }
    
    func testCreateToDo() {
        presenter.createToDo()
        XCTAssertTrue(mockRouter.navigateToCreateTodoCalled)
    }
    
    func testFetchData() {
        presenter.fetchData()
        XCTAssertTrue(mockInteractor.fetchDataCalled)
    }
    
    func testConfigure() {
        let todo = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        presenter.todos = [todo]
        let indexPath = IndexPath(row: 0, section: 0)
        let mockCell = TodoTableViewCell(style: .default, reuseIdentifier: "ToDoCell")
    
        presenter.configure(cell: mockCell, at: indexPath)
        
        XCTAssertEqual(mockCell.titleTextView.text, "Task 1")
        XCTAssertEqual(mockCell.descriptionTextView.text, "Description 1")
    }
    
    func testGetTodosCount() {
        let todo1 = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        let todo2 = Todo(id: UUID(), title: "Task 2", description: "Description 2", date: "2025-03-16", isCompleted: false)
        presenter.todos = [todo1, todo2]
        
        let count = presenter.getTodosCount()
        
        XCTAssertEqual(count, 2)
    }
    
    func testGetTodosCountString() {
        let todo1 = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        let todo2 = Todo(id: UUID(), title: "Task 2", description: "Description 2", date: "2025-03-16", isCompleted: false)
        presenter.todos = [todo1, todo2]
        
        let countString = presenter.getTodosCountString()
        
        XCTAssertEqual(countString, "2 Задачи")
    }
    
    func testClearSearchResult() {
        let todo1 = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        let todo2 = Todo(id: UUID(), title: "Task 2", description: "Description 2", date: "2025-03-16", isCompleted: false)
        presenter.todos = [todo1]
        presenter.todosBeforeFiltering = [todo1, todo2]
        
        presenter.clearSearchResult()
        
        XCTAssertEqual(presenter.todos.count, 2)
        XCTAssertTrue(mockView.reloadTableViewCalled)
        XCTAssertTrue(mockView.updateFooterCalled)
    }
}
