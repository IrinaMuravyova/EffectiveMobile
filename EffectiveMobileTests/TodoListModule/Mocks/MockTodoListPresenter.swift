//
//  MockTodoListPresenter.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class MockTodoListPresenter: TodoListPresenterProtocol {
    var fetchDataCalled = false
    var createToDoCalled = false
    var updateSearchResultCalled = false
    var clearSearchResultCalled = false
    var getTodosCountCalled = false
    var getTodosCountStringCalled = false
    var configureCellCalled = false
    var completeButtonTappedCalled = false
    
    var todosCountToReturn = 0
    var todosCountStringToReturn = "0 задач"
    
    func fetchData() {
        fetchDataCalled = true
    }
    
    func createToDo() {
        createToDoCalled = true
    }
    
    func updateSearchResult(with text: String) {
        updateSearchResultCalled = true
    }
    
    func clearSearchResult() {
        clearSearchResultCalled = true
    }
    
    func getTodosCount() -> Int {
        getTodosCountCalled = true
        return todosCountToReturn
    }
    
    func getTodosCountString() -> String {
        getTodosCountStringCalled = true
        return todosCountStringToReturn
    }
    
    func configure(cell: TodoTableViewCell, at indexPath: IndexPath) {
        configureCellCalled = true
    }
    
    func completeButtonTapped(for id: UUID, at index: IndexPath) {
        completeButtonTappedCalled = true
    }
}
