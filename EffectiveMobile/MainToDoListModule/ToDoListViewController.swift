//
//  ToDoListViewController.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 10.03.2025.
//

import UIKit

protocol ToDoListViewProtocol: AnyObject {
    func updateFooter()
    func reloadTableView()
    func showShareActionAlert()
}

final class ToDoListViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private let searchControllerBackgroundColor = UIColor(hex: "#272729")
    private let footerColor = UIColor(hex: "#272729")
    private let searchCancelButtonColor = UIColor(hex: "#272729")
    private let footerButtonColor = UIColor(hex: "#FED702")
    private let alertButtonColor = UIColor(hex: "#FED702")
    private var tableView: UITableView!
    private var toolBar = UIToolbar()
    private let footerLabel = UILabel()
    
    var presenter: ToDoListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.fetchData()
    }
    
    @objc private func addTapped() {
        presenter?.createToDo()
   }
}

// MARK: - Private methods
extension ToDoListViewController {
    private func setupUI() {
        setupTitle()
        setupSearchController()
        setupTableView()
        setupToolBar()
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
       
        searchController.searchBar.delegate = self
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .tintColor = searchCancelButtonColor
        
        let textField = searchController.searchBar.searchTextField
        textField.backgroundColor = searchControllerBackgroundColor
        
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
    
    private func setupToolBar() {
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.backgroundColor = footerColor
        view.addSubview(toolBar)
        
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 49)
        ])
        
        footerLabel.text = presenter?.getTodosCountString()
        footerLabel.font = UIFont.systemFont(ofSize: 11)
        footerLabel.sizeToFit()
        footerLabel.translatesAutoresizingMaskIntoConstraints = false

        footerLabel.setLetterSpacing(0.06)
        let labelItem = UIBarButtonItem(customView: footerLabel)
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(addTapped)
        )
        addButton.tintColor = footerButtonColor
        
        let flexibleSpaceFirst = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpaceSecond = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([flexibleSpaceFirst, labelItem, flexibleSpaceSecond, addButton], animated: false)
    }
}

// MARK: - ToDoListViewProtocol
extension ToDoListViewController: ToDoListViewProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func updateFooter() {
        footerLabel.text = presenter?.getTodosCountString()
    }
    
    func showShareActionAlert() {
        let alert = UIAlertController(title: "Функция в разработке",
                                      message: "Мы скоро добавим эту функцию",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        okAction.setValue(alertButtonColor, forKey: "titleTextColor")
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}


extension ToDoListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        presenter?.updateSearchResult(with: searchText)
    }
    // MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.clearSearchResult()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getTodosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        cell.presenter = presenter
        presenter?.configure(cell: cell, at: indexPath.row)    
        return cell
    }
}
