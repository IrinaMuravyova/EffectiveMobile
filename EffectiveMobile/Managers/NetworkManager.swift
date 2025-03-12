//
//  NetworkManager.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchToDos(completion: @escaping (Result<[ToDo], Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let urlString = "https://dummyjson.com/todos/"
    
    private func intToUUID(_ int: Int) -> UUID {
        let uuidString = String(int)
        let uuid = UUID(uuidString: uuidString) ?? UUID()
        return uuid
    }
    
    func fetchToDos(completion: @escaping (Result<[ToDo], any Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 1)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ToDoAPIResponse.self, from: data)
                let todos = decodedResponse.todos.map { todo in
                    ToDo(
                        id: self.intToUUID(todo.id),
                        title: todo.todo,
                        description: "",
                        date: Date().formattedString(),
                        isCompleted: todo.completed
                    )
                }
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
