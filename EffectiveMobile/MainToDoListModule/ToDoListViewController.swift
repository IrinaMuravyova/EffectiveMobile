//
//  ToDoListViewController.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import UIKit

protocol ToDoListViewProtocol: AnyObject {
    
}

final class ToDoListViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchControllerBackgroundColor = "#272729"
    
    var presenter: ToDoListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private methods
extension ToDoListViewController {
    private func setupUI() {
        setupTitle()
        setupSearchController()
    }
    
    private func setupTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Задачи"
       
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            
            navigationBar.largeTitleTextAttributes = [
                .font: UIFont.systemFont(ofSize: 34, weight: .bold)
            ]
        }
    }
    
    private func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
       
        let textField = searchController.searchBar.searchTextField
        textField.backgroundColor = UIColor(hex: searchControllerBackgroundColor)
        
    
    }
}

// MARK: - ToDoListViewProtocol
extension ToDoListViewController: ToDoListViewProtocol {
    
}

// MARK: - UIColor
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - UISearchResultsUpdating
extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        presenter?.updateSearchResult(with: searchText)
    }
}
