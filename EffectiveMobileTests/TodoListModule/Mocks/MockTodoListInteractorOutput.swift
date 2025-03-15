//
//  MockTodoListInteractorOutput.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class MockTodoListInteractorOutput: TodoListInteractorOutputProtocol {
    var didLoadToDoListCalled = false
    var setFilteredTodosCalled = false
    var todoDidDeletedCalled = false
    var updateTodoCellCalled = false
    
    func didLoadToDoList(_ todos: [Todo]) {
        didLoadToDoListCalled = true
    }
    
    func setFilteredTodos() {
        setFilteredTodosCalled = true
    }
    
    func todoDidDeleted(with id: UUID) {
        todoDidDeletedCalled = true
    }
    
    func updateTodoCell(at indexPath: IndexPath, with todo: Todo) {
        updateTodoCellCalled = true
    }
}
