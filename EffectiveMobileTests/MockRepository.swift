//
//  MockRepository.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class MockRepository: RepositoryProtocol {
    var fetchToDosCalled = false
    var getToDosCalled = false
    var deleteTodoCalled = false
    var changeTodoCompleteCalled = false
    var updateTodoCalled = false
    var createTodoCalled = false
    
    var fetchToDosResult: Result<[Todo], Error>?
    var getToDosResult: Result<[Todo], Error>?
    var deleteTodoResult: Result<UUID, Error>?
    var updateTodoResult: Result<Void, Error>?
    var createTodoResult: Result<Void, Error>?
    
    func fetchToDos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        fetchToDosCalled = true
        if let result = fetchToDosResult {
            completion(result)
        }
    }
    
    func getToDos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        getToDosCalled = true
        if let result = getToDosResult {
            completion(result)
        }
    }
    
    func deleteTodo(with id: UUID, completion: @escaping (Result<UUID, Error>) -> Void) {
        deleteTodoCalled = true
        if let result = deleteTodoResult {
            completion(result)
        }
    }
    
    func changeTodoComplete(for id: UUID, with state: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        changeTodoCompleteCalled = true
        completion(.success(()))
    }
    
    func updateTodo(for todo: Todo, withTitle: String, date: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        updateTodoCalled = true
        if let result = updateTodoResult {
            completion(result)
        }
    }
    
    func createTodo(title: String, date: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        createTodoCalled = true
        if let result = createTodoResult {
            completion(result)
        }
    }
}
