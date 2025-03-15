//
//  CreateTodoPresenter.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import Foundation

protocol CreateTodoPresenterProtocol: AnyObject {
    var router: CreateTodoRouterProtocol? { get set }
    func createTodo(title: String, date: String, description: String)
}

final class CreateTodoPresenter {
    weak var view: CreateTodoViewProtocol?
    var interactor: CreateTodoInteractorProtocol?
    var router: CreateTodoRouterProtocol?
}

extension CreateTodoPresenter: CreateTodoPresenterProtocol {
    func createTodo(title: String, date: String, description: String) {
        guard TodoValidator.validateTitle(title) else {
            view?.showAlertFor(message: "Название не может быть пустым")
            return
        }
  
        guard TodoValidator.validateDate(date) else {
            view?.showAlertFor(message: "Некорректный формат даты. Укажите дату в формате: 03/03/25")
            return
        }
        interactor?.createTodo(title: title, date: date, description: description)
    }
}

extension CreateTodoPresenter: CreateTodoInteractorOutputProtocol {
    func todoDidCreated() {
        router?.delegate?.todoDidCreated()
        DispatchQueue.main.async{
            self.view?.closeScreen()
        }
    }
}
