//
//  ToDoListPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import Foundation

protocol ToDoListPresenterProtocol: AnyObject {
    func updateSearchResult(with: String)
    func markToDoIsCompleted()
}

class ToDoListPresenter {
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorProtocol?
    var router: ToDoListRouterProtocol?
}

extension ToDoListPresenter: ToDoListPresenterProtocol {
    func updateSearchResult(with: String) {
        // TODO: add filtering logic
    }
    
    func markToDoIsCompleted() {
        // TODO: add todo's mark logic
    }
}
