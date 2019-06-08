//
//  RecipeListTableViewCell.swift
//  Re-Consumer
//
//  Created by iniad on 2019/06/08.
//  Copyright © 2019 harutaYamada. All rights reserved.
//

import UIKit

class RecipeListTableViewCell: UITableViewCell {

    let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private(set) var recipe: Recipe? {
        didSet {
            self.label.text = self.recipe?.name
        }
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        self.contentView.addSubview(recipeImageView)
        self.contentView.addSubview(label)
        
        self.recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.recipeImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
        self.recipeImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        self.recipeImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15)
        self.recipeImageView.widthAnchor.constraint(equalToConstant: 100)
        self.recipeImageView.heightAnchor.constraint(equalTo: self.recipeImageView.widthAnchor)
        self.recipeImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10)
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10)
        self.label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10)
        self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(recipe: Recipe) {
        self.recipe = recipe
    }
}
