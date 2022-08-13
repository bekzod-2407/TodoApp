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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.Plist")
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        createBarButtonItems()
        // user’s home directory // append the given path
        
        print(dataFilePath)
//        loadItems()
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
//    private func loadItems() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                todoItems = try decoder.decode([TodoItem].self, from: data)
//            }catch {
//                print("cannot decode TodoItem \(error.localizedDescription)")
//            }
//        }
//    }
}

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
        
            todoItems[indexPath.row].isDone = !todoItems[indexPath.row].isDone
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
 
    }
}

