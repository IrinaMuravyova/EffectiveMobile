//
//  ToDo.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

class ToDo {
    let id: UUID
    var title: String
    var description: String
    var date: String
    var isCompleted: Bool

    init(id: UUID, title: String, description: String, date: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isCompleted = isCompleted
    }
            
    init?(from toDoCD: ToDoCD) {
        guard let id = toDoCD.id,
              let title = toDoCD.title,
              let description = toDoCD.todoDescription,
              let date = toDoCD.date else { return nil }
        
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isCompleted = toDoCD.isCompleted
    }
}
