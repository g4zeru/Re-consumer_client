//
//  RecipeListViewController.swift
//  Re-Consumer
//
//  Created by iniad on 2019/06/08.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import Foundation
import UIKit
import Network

class RecipeListViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecipeListTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var leftButton: UIBarButtonItem!
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    let session = NetworkSession(model: RequestModel(domain: "http://d811c88a.ngrok.io/materials/%E3%81%98%E3%82%83%E3%81%8C%E3%81%84%E3%82%82", path: "", method: .get))
    
    let jsonDecoder = JSONDecoder()
    
    var recipeList: RecipeList? {
        didSet {
            
            self.tableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = backView
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leftButton = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(tappedLeftBarButton))
        self.navigationItem.title = "レシピ"
        self.navigationItem.leftBarButtonItem = leftButton
        self.session.delegate = self
        self.session.startSession()
    }
    
    @objc func tappedLeftBarButton() {
        let viewController = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "camera")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeList?.recipes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecipeListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecipeListTableViewCell
        cell.set(recipe: self.recipeList!.recipes[indexPath.item])
        return cell
    }
}

extension RecipeListViewController: UITableViewDelegate {
    
}

extension RecipeListViewController: NetworkSessionDelegate {
    func responce(json: Data) {
        self.recipeList = try! self.jsonDecoder.decode(RecipeList.self, from: json)
    }
    
    func responce(error: Error) {
        print(error)
    }
}
