//
//  ToDoListInteractor.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    
}

class ToDoListInteractor {
    weak var presenter: ToDoListPresenterProtocol?
}

extension ToDoListInteractor: ToDoListInteractorProtocol {
    
}

