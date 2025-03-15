//
//  MockTodoListRouter.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class MockTodoListRouter: TodoListRouterProtocol {
    var navigateToCreateTodoCalled = false
    var navigateToEditTodoCalled = false
    
    func navigateToCreateTodo() {
        navigateToCreateTodoCalled = true
    }
    
    func navigateToEditTodo(with todo: Todo, at index: IndexPath) {
        navigateToEditTodoCalled = true
    }
}
