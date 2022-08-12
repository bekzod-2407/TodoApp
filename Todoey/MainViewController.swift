//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let items: [String] = ["Kim","Jon", "Bon" , "Xon"]
    
    private lazy var tavleView: UITableView = {
        var view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(TodoCell.self, forCellReuseIdentifier: TodoCell.cellName)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubView()
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    private func setupSubView() {
        view.addSubview(tavleView)
        
        NSLayoutConstraint.activate([
            tavleView.topAnchor.constraint(equalTo: view.topAnchor),
            tavleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tavleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tavleView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.cellName) as? TodoCell else {return UITableViewCell()}
        cell.nameLabel.text = items[indexPath.row]
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

