//
//  ShoppingListTableViewController.swift
//  ShoppingList23
//
//  Created by Karissa McDaris on 12/7/18.
//  Copyright © 2018 Karissa McDaris. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController, CheckBoxTableViewCellButtonDelegate {
    func cellButtonTapped(_ cell: ShoppingListTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let item = fetchResultsController.object(at: indexPath)
            ShoppingItemController.sharedInstance.toggle(item: item)
            cell.toggleCell(with: item)
        }
    }
    
    //MARK: - fetch results controller
    let fetchResultsController: NSFetchedResultsController<ShoppingItem> = {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        let itemDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [itemDescriptor]
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    //MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error)
        }
        fetchResultsController.delegate = self
    }
    
    //MARK: - actions
    @IBAction func addItemButtonTapped(_ sender: Any) {
        showAlertController()
    }
    
    // MARK: - table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    //MARK: - configuring the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath) as! ShoppingListTableViewCell
        
        cell.delegate = self
        let item = fetchResultsController.object(at: indexPath)
        cell.item = item
        return cell
    }
    
    //MARK: - swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchResultsController.object(at: indexPath)
            ShoppingItemController.sharedInstance.deleteItem(item: item)
        }    
    }
}

//MARK: - conforming to fetched results delegate
extension ShoppingListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let indexPath = newIndexPath else { return }
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - alert controller
extension ShoppingListTableViewController {
    func showAlertController(){
        let alertController = UIAlertController(title: "Remembered an item you needed?", message: nil, preferredStyle: .alert)
        alertController.addTextField { (itemTextField) in
            itemTextField.placeholder = "Enter item here 📝"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let itemTextField = alertController.textFields?.first else {return}
            ShoppingItemController.sharedInstance.createItem(with: itemTextField.text ?? "")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
}
