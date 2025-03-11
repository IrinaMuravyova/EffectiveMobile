//
//  Repository.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import Foundation

protocol RepositoryProtocol {
    func getToDos(completion: @escaping (Result<[ToDo], Error>) -> Void)
}

class Repository: RepositoryProtocol {
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
    
    func getToDos(completion: @escaping (Result<[ToDo], Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch") // debugging code
            let isFirstLaunch = self.userDefaults.bool(forKey: self.isFirstLaunchKey)
    
            if isFirstLaunch {
                self.networkManager.fetchToDos { result in
                    switch result {
                    case .success(let todos):
                        // TODO:  save to coreData
                        
                            DispatchQueue.main.async {
                                completion(.success(todos))
                                self.userDefaults.set(false, forKey: self.isFirstLaunchKey)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            } else {
                // TODO:  add load from coreData
            }
        }
    }
}
