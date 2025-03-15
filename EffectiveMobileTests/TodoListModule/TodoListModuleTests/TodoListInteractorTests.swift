//
//  TodoListInteractorTests.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class TodoListInteractorTests: XCTestCase {
    var interactor: TodoListInteractor!
    var mockRepository: MockRepository!
    var mockOutput: MockTodoListInteractorOutput!
    
    override func setUp() {
        super.setUp()
        interactor = TodoListInteractor()
        mockRepository = MockRepository()
        mockOutput = MockTodoListInteractorOutput()
        
        interactor.repository = mockRepository
        interactor.presenter = mockOutput
    }
    
    override func tearDown() {
        interactor = nil
        mockRepository = nil
        mockOutput = nil
        super.tearDown()
    }
    
    func testFetchData() {
        let todo = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        mockRepository.fetchToDosResult = .success([todo])
        
        let expectation = XCTestExpectation(description: "Fetch data completed")
        interactor.fetchData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockRepository.fetchToDosCalled)
            XCTAssertTrue(self.mockOutput.didLoadToDoListCalled)
            XCTAssertTrue(self.mockOutput.setFilteredTodosCalled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testGetData() {
        let todo = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        mockRepository.getToDosResult = .success([todo])
        
        let expectation = XCTestExpectation(description: "Get data completed")
        interactor.getData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockRepository.getToDosCalled)
            XCTAssertTrue(self.mockOutput.didLoadToDoListCalled)
            expectation.fulfill()
        }
    
        wait(for: [expectation], timeout: 2)
    }
    
    func testDeleteTodo() {
        let todoId = UUID()
        mockRepository.deleteTodoResult = .success(todoId)
    
        interactor.deleteTodo(with: todoId)
        
        XCTAssertTrue(mockRepository.deleteTodoCalled)
        XCTAssertTrue(mockOutput.todoDidDeletedCalled)
    }
    
    func testMarkTodoCompleted() {
        let todoId = UUID()
        
        interactor.markTodoCompleted(for: todoId, with: true)
        
        XCTAssertTrue(mockRepository.changeTodoCompleteCalled)
    }
    
    func testUpdateTodoCell() {
        let todo = Todo(id: UUID(), title: "Task 1", description: "Description 1", date: "2025-03-15", isCompleted: false)
        let indexPath = IndexPath(row: 0, section: 0)
        
        interactor.updateTodoCell(at: indexPath, with: todo)
        
        XCTAssertTrue(mockOutput.updateTodoCellCalled)
    }
}
