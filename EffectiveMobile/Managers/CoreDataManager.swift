//
//  CoreDataManager.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import CoreData

protocol CoreDataManagerProtocol: AnyObject {
    
}

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
}

extension CoreDataManager: CoreDataManagerProtocol {
    
}
