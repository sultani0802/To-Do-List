//
//  TodoListTableViewController.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-22.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    // MARK: - Variables
    let CELL_IDENTIFIER: String = "ToDoItemCell"
    var itemArray = ["Milk", "Bread", "Chocolate"]
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK : - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check off/on the item in the list
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the cell
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField() // Created to have access to the text the user enters
        
        let alertController = UIAlertController(title: "Add item to list", message: "", preferredStyle: .alert)
        
        // This closure is called when the textfield is ADDED to the alert controller
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter item..."
            textField = alertTextField
        }
        
        // Add the item to the list
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        
        // Don't add the item to the list
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
