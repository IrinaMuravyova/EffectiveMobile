//
//  Repository.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import Foundation

protocol RepositoryProtocol {
    func fetchToDos(completion: @escaping (Result<[Todo], Error>) -> Void)
    func getToDos(completion: @escaping (Result<[Todo], Error>) -> Void)
    func deleteTodo(with: UUID, completion: @escaping (Result<UUID, Error>) -> Void)
    func changeTodoComplete(for id: UUID, with state: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTodo(for todo: Todo, withTitle: String, date: String, description: String, completion: @escaping (Result<Void, Error>) -> Void)
    func createTodo(title: String, date: String, description: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class Repository: RepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    private let dataManager: CoreDataManagerProtocol
    private let userDefaults: UserDefaults
    private let isFirstLaunchKey = "isFirstLaunch"
    
    init(
        networkManager: NetworkManagerProtocol,
        dataManager: CoreDataManagerProtocol,
        userDefaults: UserDefaults = .standard
    ) {
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.userDefaults = userDefaults
    }
    
    func fetchToDos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
//            UserDefaults.standard.set(true, forKey: "isFirstLaunch") // debugging code
            let isFirstLaunch = self.userDefaults.bool(forKey: self.isFirstLaunchKey)
    
            if isFirstLaunch {
                self.networkManager.fetchToDos { result in
                    switch result {
                    case .success(let todos):
                        self.dataManager.update(todos) { _ in
                            DispatchQueue.main.async {
                                completion(.success(todos))
                                self.userDefaults.set(false, forKey: self.isFirstLaunchKey)
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            } else {
                self.loadLocalToDos(completion: completion)
            }
        }
    }
    
    func getToDos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.loadLocalToDos(completion: completion)
        }
    }
    
    func deleteTodo(with id: UUID, completion: @escaping (Result<UUID, Error>) -> Void) {
        dataManager.deleteToDo(with: id) { result in
            switch result {
            case .success:
                completion(.success(id))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func changeTodoComplete(for id: UUID, with state: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
    
        dataManager.changeCompletionState(for: id, with: state) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func updateTodo(for todo: Todo, withTitle: String, date: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let updatedTodo = todo
        updatedTodo.title = withTitle
        updatedTodo.date = date
        updatedTodo.description = description
        
        dataManager.updateToDo(updatedTodo) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print("Error saving to Core Data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func createTodo(title: String, date: String, description: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let newToDo = Todo(
            id: UUID(),
            title: title,
            description: description,
            date: date,
            isCompleted: false
        )
        
        dataManager.createToDo(with: newToDo) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK:- Private methods
extension Repository {
    private func loadLocalToDos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        self.dataManager.getTodos { localTodosResult in
            switch localTodosResult {
            case .success(let localTodos):
                if !localTodos.isEmpty {
                    DispatchQueue.main.async {
                        completion(.success(localTodos))
                    }
                    return
                }
            case .failure:
                break
            }
        }
    }
}
