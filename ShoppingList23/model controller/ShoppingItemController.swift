//
//  ShoppingItemController.swift
//  ShoppingList23
//
//  Created by Karissa McDaris on 12/7/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import Foundation
import CoreData

class ShoppingItemController {
    
    //MARK: - shared instance (private init)
    static let sharedInstance = ShoppingItemController(); private init(){}
    
    //MARK: - CRUD functions
    func createItem(with name: String){
        ShoppingItem(name: name)
        saveToPersistance()
    }
    
    func deleteItem(item: ShoppingItem){
        CoreDataStack.context.delete(item)
        saveToPersistance()
    }
    
    //MARK: - toggle function
    func toggle(item: ShoppingItem){
        if item.isChecked == false{
            item.isChecked = true
        } else {
            item.isChecked = false
        }
        saveToPersistance()
    }
    
    //MARK: - save to persistance
    func saveToPersistance(){
        do {
            try CoreDataStack.context.save()
        } catch {
            print("there was an \(error) in \(#function): \(error.localizedDescription)")
        }
    }
}
