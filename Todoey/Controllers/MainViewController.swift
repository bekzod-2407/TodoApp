//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class MainViewController: UIViewController {
    
    var todoItems = [TodoItem]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    private lazy var searchBar: UISearchBar = {
        var view = UISearchBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Search"
        view.frame = CGRect(x: 0, y: 0, width: (navigationController?.view.bounds.size.width)!, height: 64)
        view.barStyle = .default
        view.isTranslucent = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubView()
        createBarButtonItems()
        // user’s home directory // append the given path
        loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        searchBar.delegate = self
    }
    private func setupSubView() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        navigationItem.title = "TODO APP"
        view.addSubview(tavleView)
        view.addSubview(searchBar)
        let viewsHeight =  navigationController!.navigationBar.bottomAnchor
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor ),
            tavleView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
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
        let action = UIAlertAction(title: "Add item", style: .default) { [self] action in
            
            let newItem = TodoItem(context: contex)
            guard let text = self.alertTextField.text else {return}
            newItem.title = text
            newItem.isDone =  false
            todoItems.append(newItem)
            
            saveItem()
            
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Create a new item"
            self.alertTextField = textField
        }
        self.tavleView.reloadData()
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    private func saveItem() {
        do {
            try contex.save()
        } catch {
            print("cannot save item contex error: \(error)")
        }
        self.tavleView.reloadData()
    }
    
    private func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest() ) {
        do {
            todoItems =  try contex.fetch(request)
        }catch {
            print("Hello")
        }
        tavleView.reloadData()
    }
}


//MARK: - TableViewDelegate Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.cellName) as? TodoCell else {return UITableViewCell()}
        let item = todoItems[indexPath.row]
        cell.nameLabel.text = item.title
        cell.accessoryType = item.isDone ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//                contex.delete(todoItems[indexPath.row])
//                todoItems.remove(at: indexPath.row)
        todoItems[indexPath.row].isDone = !todoItems[indexPath.row].isDone
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - searchBarDelegate Methods
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        guard let text = searchBar.text else {return}
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

