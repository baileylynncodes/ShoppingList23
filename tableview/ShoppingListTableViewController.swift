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
    
    let fetchResultsController: NSFetchedResultsController<ShoppingItem> = {
        let request: NSFetchRequest<ShoppingItem> = ShoppingItem.fetchRequest()
        let itemDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [itemDescriptor]
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error)
        }
        fetchResultsController.delegate = self
    }
    
    @IBAction func addItemButtonTapped(_ sender: Any) {
        showAlertController()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath) as! ShoppingListTableViewCell
        
        cell.delegate = self
        
        let item = fetchResultsController.object(at: indexPath)
        
        cell.item = item

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = fetchResultsController.object(at: indexPath)
            ShoppingItemController.sharedInstance.deleteItem(item: item)
        }    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

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

