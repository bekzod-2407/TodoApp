//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var todoItems: [String] = ["A","A","B"]
    var defaults = UserDefaults.standard
    private lazy var tavleView: UITableView = {
        var view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(TodoCell.self, forCellReuseIdentifier: TodoCell.cellName)
        return view
    }()
    private lazy var alertTextField: UITextField = {
        var view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        createBarButtonItems()
        if let items  = defaults.array(forKey: "TodoItems") as? [String] {
            todoItems = items
        }
     }
    private func setupSubView() {
        navigationItem.title = "TODO APP"
        view.addSubview(tavleView)
        NSLayoutConstraint.activate([
            tavleView.topAnchor.constraint(equalTo: view.topAnchor),
            tavleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tavleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tavleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    private func createBarButtonItems() {

        let barItem: UIBarButtonItem = {
            let view = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
            return view
        }()
        navigationItem.setRightBarButton(barItem, animated: true)
    }
    @objc func addButtonPressed() {
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            guard let text = self.alertTextField.text else {return}
            self.todoItems.append(text)
            self.defaults.set(self.todoItems, forKey: "TodoItems")
            self.tavleView.reloadData()
        }
        alert.addTextField { textField in
            textField.placeholder = "Create a new item"
            self.alertTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.cellName) as? TodoCell else {return UITableViewCell()}
        cell.nameLabel.text = todoItems[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
}

