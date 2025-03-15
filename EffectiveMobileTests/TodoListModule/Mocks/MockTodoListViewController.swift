//
//  TodoListViewController.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile
import UIKit

class MockNavigationController: UINavigationController {
    var pushViewControllerCalled = false
    var presentViewControllerCalled = false
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
    }
    
    override func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentViewControllerCalled = true
    }
}

class MockTodoListViewController: TodoListViewController {
    var pushViewControllerCalled = false
    var presentViewControllerCalled = false
    var mockNavigationController: MockNavigationController!
    
    override var navigationController: UINavigationController? {
        return mockNavigationController
    }
    
    override func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentViewControllerCalled = true
    }
}
