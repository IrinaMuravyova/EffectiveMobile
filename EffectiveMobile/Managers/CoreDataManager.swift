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
    func createToDo(with toDo: ToDo, completion: @escaping (Result<Void, Error>) -> Void)
    func updateToDo(_ toDo: ToDo, completion: @escaping (Result<Void, any Error>) -> Void)
    func changeCompletionState(for id: UUID, with state: Bool, completion: @escaping (Result<Void, Error>) -> Void)
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
        backgroundContext.automaticallyMergesChangesFromParent = true
    }
}
// MARK: - Private methods
extension CoreDataManager {
    private func deleteTodos(completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            let fetchRequest: NSFetchRequest<ToDoCD> = ToDoCD.fetchRequest()
            
            do {
                let todos = try backgroundContext.fetch(fetchRequest)
                for todo in todos {
                    backgroundContext.delete(todo)
                }
                try self.backgroundContext.save()
                completion(.success(()))
            } catch {
                print("CoreData delete error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    private func saveBackgroundContext(completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            if self.backgroundContext.hasChanges {
                do {
                    try self.backgroundContext.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.success(()))
            }
        }
    }
}

// MARK: - CoreDataManagerProtocol
extension CoreDataManager: CoreDataManagerProtocol {
    
    func getTodos(completion: @escaping (Result<[ToDo], Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            let fetchRequest = NSFetchRequest<ToDoCD>(entityName: "ToDoCD")
                
            do {
                let toDoCDs = try self.backgroundContext.fetch(fetchRequest)
                let todos = toDoCDs.compactMap {
                        ToDo(from: $0)
                    }
                completion(.success(todos))
            } catch {
                print("CoreData fetch error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func update(_ todos: [ToDo], completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform {[weak self] in
            guard let self = self else { return }
          
            self.deleteTodos { result in
                switch result {
                case .success:
                    todos.forEach {self.createToDo(with: $0) { _ in } }
                    self.saveBackgroundContext(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteToDo(with id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
                    
            let fetchRequest: NSFetchRequest<ToDoCD> = ToDoCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
     
            do {
                if let taskToDelete = try backgroundContext.fetch(fetchRequest).first {
                    backgroundContext.delete(taskToDelete)
                    self.saveBackgroundContext(completion: completion)
                } else {
                    print("Task not found")
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createToDo(with toDo: ToDo, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }

            let newToDoCD = ToDoCD(context: self.backgroundContext)
            newToDoCD.id = toDo.id
            newToDoCD.title = toDo.title
            newToDoCD.todoDescription = toDo.description
            newToDoCD.date = toDo.date
            newToDoCD.isCompleted = toDo.isCompleted
            
            self.saveBackgroundContext(completion: completion)
        }
    }
    
    func updateToDo(_ toDo: ToDo, completion: @escaping (Result<Void, any Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
                        
            let fetchRequest: NSFetchRequest<ToDoCD> = ToDoCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", toDo.id as CVarArg)
        
            do {
                if let todoToUpdate = try backgroundContext.fetch(fetchRequest).first {
                    todoToUpdate.title = toDo.title
                    todoToUpdate.todoDescription = toDo.description
                    todoToUpdate.date = toDo.date
                    todoToUpdate.isCompleted = toDo.isCompleted
                    
                    self.saveBackgroundContext(completion: completion)
                } else {
                    print("Task not found")
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func changeCompletionState(for id: UUID, with state: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            
            let fetchRequest: NSFetchRequest<ToDoCD> = ToDoCD.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
            do {
                if let todoToUpdate = try backgroundContext.fetch(fetchRequest).first {
                    todoToUpdate.isCompleted = state
                    self.saveBackgroundContext(completion: completion)
                } else {
                    print("Task not found")
                }
            } catch {
                print("Failed to update task: \(error.localizedDescription)")
            }
        }
    }
}
