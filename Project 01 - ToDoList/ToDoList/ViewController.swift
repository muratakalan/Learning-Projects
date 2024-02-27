//
//  ViewController.swift
//  ToDoList
//
//  Created by murat akalan on 27.02.2024.
//

import UIKit

class TodoManager {
    static let shared = TodoManager()
    
    private let userDefaults = UserDefaults.standard
    private let todoKey = "items"
    
    func fetchItems() -> [String] {
        return userDefaults.stringArray(forKey: todoKey) ?? []
    }
    
    func addItem(_ item: String) {
        var currentItems = fetchItems()
        currentItems.append(item)
        userDefaults.set(currentItems, forKey: todoKey)
    }
    
    func removeItem(at index: Int) {
        var currentItems = fetchItems()
        currentItems.remove(at: index)
        userDefaults.set(currentItems, forKey: todoKey)
    }
}

class ViewController: UIViewController, UITableViewDataSource {
    private let table = UITableView()
    private var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = TodoManager.shared.fetchItems()
        title = "To Do List"
        
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self // Added delegate
        view.addSubview(table)
        table.frame = view.bounds
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new to-do list item!", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Enter Item..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            if let item = alert.textFields?.first?.text, !item.isEmpty {
                TodoManager.shared.addItem(item)
                self?.items.append(item)
                self?.table.reloadData()
            }
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoManager.shared.removeItem(at: indexPath.row)
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
