//
//  ToDoListInteractor.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    func getData()
}

class ToDoListInteractor {
    weak var presenter: ToDoListInteractorOutputProtocol?
    var repository: RepositoryProtocol?
}

extension ToDoListInteractor: ToDoListInteractorProtocol {
    func getData() {
        DispatchQueue.global(qos: .background).async {
            self.repository?.getToDos { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let todos):
                        self.presenter?.didLoadToDoList(todos)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
