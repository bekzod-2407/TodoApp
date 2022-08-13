//
//  TodeCell.swift
//  Todoey
//
//  Created by Bekzod Qahhorov on 11/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell  {
   
   static var cellName  = String(describing: TodoCell.self)
    
    private(set) lazy var  nameLabel: UILabel = {
        var view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = .monospacedSystemFont(ofSize: 34, weight: .regular)
        return view
    }()
    
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10)
        ])
    }
    

}
