//
//  MockTodoListInteractor.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class MockTodoListInteractor: TodoListInteractorProtocol {
    var fetchDataCalled = false
    var markTodoCompletedCalled = false
    var deleteTodoCalled = false
    var getDataCalled = false
    var updateTodoCellCalled = false
    
    func fetchData() {
        fetchDataCalled = true
    }
    
    func markTodoCompleted(for id: UUID, with isCompleted: Bool) {
        markTodoCompletedCalled = true
    }
    
    func deleteTodo(with id: UUID) {
        deleteTodoCalled = true
    }
    
    func getData() {
        getDataCalled = true
    }
    
    func updateTodoCell(at indexPath: IndexPath, with todo: Todo) {
        updateTodoCellCalled = true
    }
}
