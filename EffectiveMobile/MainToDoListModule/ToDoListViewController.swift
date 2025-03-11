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
    private var tableView: UITableView!
    
    let todos = ToDo.getTodos()
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
        setupTableView()
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
        
        view.addSubview(searchController.searchBar)
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "ToDoCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - ToDoListViewProtocol
extension ToDoListViewController: ToDoListViewProtocol {
    
}

// MARK: - UISearchResultsUpdating
extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        presenter?.updateSearchResult(with: searchText)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        //debugging code
        if todo.isCompleted { cell.isCompletedConfigure(with: todo)} else {
            cell.isNotCompletedConfigure(with: todo)}
        
        cell.presenter = presenter
        return cell
    }
}
