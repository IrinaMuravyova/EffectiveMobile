//
//  MockViewController.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

class MockViewController: UIViewController {
    var navigationController: UINavigationController?
}

class MockNavigationController: UINavigationController {
    var popViewControllerCalled = false

    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return super.popViewController(animated: animated)
    }
}

class MockEditTodoRouterDelegate: EditTodoRouterDelegate {
    var didUpdateTodoCalled = false
    var didUpdateTodoWithIndexPathCalled = false
    var updatedIndexPath: IndexPath?
    var updatedTodo: Todo?

    func didUpdateTodo() {
        didUpdateTodoCalled = true
    }

    func didUpdateTodo(with indexPath: IndexPath, todo: Todo) {
        didUpdateTodoWithIndexPathCalled = true
        updatedIndexPath = indexPath
        updatedTodo = todo
    }
}
