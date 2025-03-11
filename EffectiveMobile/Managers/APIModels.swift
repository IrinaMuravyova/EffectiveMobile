//
//  APIModels.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import Foundation

struct ToDoAPIResponse: Decodable {
    let todos: [ToDoAPI]
}

struct ToDoAPI: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
