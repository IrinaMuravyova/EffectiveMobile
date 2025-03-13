//
//  EditTodoInteractor.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 13.03.2025.
//

import Foundation

protocol EditTodoInteractorProtocol: AnyObject {

}

protocol EditTodoRepositoryOutputProtocol: AnyObject {

}

class EditTodoInteractor {
    weak var presenter: EditTodoInteractorOutputProtocol?
    var repository: RepositoryProtocol?
}

extension EditTodoInteractor: EditTodoInteractorProtocol {
    
}

extension EditTodoInteractor: EditTodoRepositoryOutputProtocol {

}
