//
//  ShoppingItem+Convenience.swift
//  ShoppingList23
//
//  Created by Karissa McDaris on 12/7/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import Foundation
import CoreData

extension ShoppingItem {
    convenience init(name: String, isChecked: Bool = false, context: NSManagedObjectContext = CoreDataStack.context){
        self.init(context: context)
        
        self.name = name
        self.isChecked = isChecked
    }
}
