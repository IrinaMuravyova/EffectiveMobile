//
//  CoreDataManager.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    func getTodos(completion: @escaping (Result<[ToDo], Error>) -> Void)
    func update(_ todos: [ToDo], completion: @escaping (Result<Void, Error>) -> Void)
    func deleteToDo(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void)
    func createToDo(with toDo: ToDo)
    func updateToDo(_ toDo: ToDo, completion: @escaping (Result<Void, any Error>) -> Void)
}

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        let modelURL = Bundle.main.url(forResource: "ToDoCD", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        persistentContainer = NSPersistentContainer(name: "ToDoCD", managedObjectModel: managedObjectModel)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        backgroundContext = persistentContainer.newBackgroundContext()
    }
}
// MARK: - Private methods
extension CoreDataManager {
    private func deleteTodos() {
        let fetchRequest: NSFetchRequest<ToDoCD> = ToDoCD.fetchRequest()

        do {
            let todos = try mainContext.fetch(fetchRequest)
            for todo in todos {
                mainContext.delete(todo)
            }
            try mainContext.save()
        } catch {
            print("CoreData delete error: \(error)")
        }
    }
}

// MARK: - CoreDataManagerProtocol
extension CoreDataManager: CoreDataManagerProtocol {
    
    func getTodos(completion: @escaping (Result<[ToDo], Error>) -> Void) {
        let fetchRequest = NSFetchRequest<ToDoCD>(entityName: "ToDoCD")
            
        mainContext.perform {
            do {
                let toDoCDs = try self.mainContext.fetch(fetchRequest)
                let todos = toDoCDs.compactMap {
                        ToDo(from: $0)
                    }
                print("Todos has been fetched from CoreData")
                completion(.success(todos))
            } catch {
                print("CoreData fetch error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func update(_ todos: [ToDo], completion: @escaping (Result<Void, Error>) -> Void) {
        mainContext.perform {[weak self] in
            do {
                self?.deleteTodos()
                todos.forEach {self?.createToDo(with: $0)}
                print("Todos has been saved at CoreData")
                try self?.mainContext.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deleteToDo(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest: NSFetchRequest<ToDoCD> = ToDoCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        backgroundContext.perform { [self] in
            do {
                if let taskToDelete = try backgroundContext.fetch(fetchRequest).first {
                    backgroundContext.delete(taskToDelete)
                    try backgroundContext.save()
                    completion(.success(()))
                } else {
                    print("Task not found")
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createToDo(with toDo: ToDo) {
        backgroundContext.perform {
            let newToDoCD = ToDoCD(context: self.backgroundContext)
            newToDoCD.id = toDo.id
            newToDoCD.title = toDo.title
            newToDoCD.todoDescription = toDo.description
            newToDoCD.date = toDo.date
            newToDoCD.isCompleted = toDo.isCompleted
            
            do {
                try self.backgroundContext.save()
            } catch {
                print("Saving error: \(error)")
            }
        }
    }
    
    func updateToDo(_ toDo: ToDo, completion: @escaping (Result<Void, any Error>) -> Void) {
        let fetchRequest: NSFetchRequest<ToDoCD> = ToDoCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", toDo.id as CVarArg)
        
        backgroundContext.perform { [self] in
            do {
                if let taskToUpdate = try backgroundContext.fetch(fetchRequest).first {
                    taskToUpdate.title = toDo.title
                    taskToUpdate.todoDescription = toDo.description
                    taskToUpdate.date = toDo.date
                    taskToUpdate.isCompleted = toDo.isCompleted
                    
                    try backgroundContext.save()
                    completion(.success(()))
                } else {
                    print("Task not found")
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
