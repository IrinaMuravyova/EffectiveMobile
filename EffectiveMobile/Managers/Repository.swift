//
//  Repository.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import Foundation

protocol RepositoryProtocol {
    func fetchToDos(completion: @escaping (Result<[ToDo], Error>) -> Void)
    func getToDos(completion: @escaping (Result<[ToDo], Error>) -> Void)
    func deleteTodo(with: UUID)
}

class Repository: RepositoryProtocol {
    private let networkManager: NetworkManagerProtocol
    private let dataManager: CoreDataManagerProtocol
    private let userDefaults: UserDefaults
    private let isFirstLaunchKey = "isFirstLaunch"
    weak var interactor: ToDoListRepositoryOutputProtocol?
    
    init(
        networkManager: NetworkManagerProtocol,
        dataManager: CoreDataManagerProtocol,
        userDefaults: UserDefaults = .standard
    ) {
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.userDefaults = userDefaults
    }
    
    func fetchToDos(completion: @escaping (Result<[ToDo], Error>) -> Void) {
        
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
    
    func getToDos(completion: @escaping (Result<[ToDo], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.loadLocalToDos(completion: completion)
        }
    }
    
    func deleteTodo(with id: UUID) {
        dataManager.deleteToDo(with: id) { [weak self] result in
            switch result {
            case .success:
                self?.interactor?.todoDidDeleted(with: id)
            case .failure(let error):
                print("Failed to delete task: \(error.localizedDescription)")
            }
        }
    }
}

// MARK:- Private methods
extension Repository {
    private func loadLocalToDos(completion: @escaping (Result<[ToDo], Error>) -> Void) {
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
