//
//  ShoppingListTableViewCell.swift
//  ShoppingList23
//
//  Created by Karissa McDaris on 12/7/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {
    
    var item : ShoppingItem? {
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: CheckBoxTableViewCellButtonDelegate?

    @IBOutlet weak var shoppingItemNameLabel: UILabel!
    @IBOutlet weak var shoppingItemCheckBoxButton: UIButton!
    
    @IBAction func checkBoxTapped(_ sender: Any) {
        delegate?.cellButtonTapped(self)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toggleCell(with item: ShoppingItem){
        if item.isChecked{
            shoppingItemCheckBoxButton.setImage(UIImage(named: "complete"), for: .normal)
        } else {
            shoppingItemCheckBoxButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }
    }
    
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

protocol CheckBoxTableViewCellButtonDelegate: class {
    func cellButtonTapped(_ cell: ShoppingListTableViewCell)
}


