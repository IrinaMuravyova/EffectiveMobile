//
//  ToDo.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

struct ToDo {
    var title: String
    var description: String
    var date: String
    var isCompleted: Bool
    
    //debugging data
    static func getTodos() -> [ToDo] {
        [
            ToDo(
                title: "Task1",
                description: "Description1Description1Description1Description1Description1Description1Description1Description1Description1Description1Description1Description1Description1Description1Description1Description1",
                date: "03.03.2025",
                isCompleted: true),
            ToDo(
                title: "Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2Task2",
                description: "Description2",
                date: "03.03.2025",
                isCompleted: false),
            ToDo(
                title: "Task3",
                description: "Description3",
                date: "03.03.2025",
                isCompleted: false),
            ToDo(
                title: "Task4",
                description: "Description4",
                date: "03.03.2025",
                isCompleted: true),
            ToDo(
                title: "Task5",
                description: "Description5",
                date: "04.03.2025",
                isCompleted: false),
            ToDo(
                title: "Task6",
                description: "Description6",
                date: "05.03.2025",
                isCompleted: false),
            ToDo(
                title: "Task7",
                description: "Description7",
                date: "06.03.2025",
                isCompleted: true),
            ToDo(
                title: "Task8",
                description: "Description8",
                date: "07.03.2025",
                isCompleted: false)
            
        ]
    }
}
