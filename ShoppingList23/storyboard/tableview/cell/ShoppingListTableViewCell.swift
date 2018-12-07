//
//  ShoppingListTableViewCell.swift
//  ShoppingList23
//
//  Created by Karissa McDaris on 12/7/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    
    //MARK: - source of truth
    var item : ShoppingItem? {
        didSet{
            updateViews()
        }
    }

    weak var delegate: CheckBoxTableViewCellButtonDelegate?
    
    //MARK: - outlets
    @IBOutlet weak var shoppingItemNameLabel: UILabel!
    @IBOutlet weak var shoppingItemCheckBoxButton: UIButton!
    
    //MARK: - actions
    @IBAction func checkBoxTapped(_ sender: Any) {
        delegate?.cellButtonTapped(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - toggle button function
    func toggleCell(with item: ShoppingItem){
        if item.isChecked{
            shoppingItemCheckBoxButton.setImage(UIImage(named: "complete"), for: .normal)
        } else {
            shoppingItemCheckBoxButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }
    }
    
    //MARK: - update views button
    func updateViews(){
        if let item = item {
            shoppingItemNameLabel.text = item.name
            if item.isChecked {
                shoppingItemCheckBoxButton.setImage(UIImage(named: "complete"), for: .normal)
            } else {
                shoppingItemCheckBoxButton.setImage(UIImage(named: "incomplete"), for: .normal)
            }
        }
    }
}

//MARK: - declaring the delegate
protocol CheckBoxTableViewCellButtonDelegate: class {
    func cellButtonTapped(_ cell: ShoppingListTableViewCell)
}


