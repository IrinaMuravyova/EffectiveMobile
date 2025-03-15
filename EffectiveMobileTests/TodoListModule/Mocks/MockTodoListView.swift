//
//  MockTodoListView.swift
//  EffectiveMobileTests
//
//  Created by Irina Muravyeva on 15.03.2025.
//

import XCTest
@testable import EffectiveMobile

class MockTodoListView: TodoListViewProtocol {
    var reloadTableViewCalled = false
    var updateFooterCalled = false
    var showShareActionAlertCalled = false
    var updateTodoStatusCalled = false
    var reloadCellCalled = false
    
    func reloadTableView() {
        reloadTableViewCalled = true
    }
    
    func updateFooter() {
        updateFooterCalled = true
    }
    
    func showShareActionAlert() {
        showShareActionAlertCalled = true
    }
    
    func updateTodoStatus(for id: UUID, at index: IndexPath) {
        updateTodoStatusCalled = true
    }
    
    func reloadCell(with indexPath: IndexPath) {
        reloadCellCalled = true
    }
}
