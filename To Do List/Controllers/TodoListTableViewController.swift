//
//  TodoListTableViewController.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-22.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    // MARK: - Constants
    let ITEM_ARRAY_DEFAULT_KEY: String = "itemArray"
    let CELL_IDENTIFIER: String = "ToDoItemCell"
    
    // MARK: - Variables
    let defaults = UserDefaults.standard
    var itemArray : [Item] = [Item]()
    weak var addActionToEnable: UIAlertAction?
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let itemArrayData = defaults.data(forKey: ITEM_ARRAY_DEFAULT_KEY) {
            // The code below is required to be able to save an array with custom object
            // i.e. [Item] instead of [String]
            // We have to encode our Item object to a Data object so that it can be saved/loaded to/from UserDefaults
            let itemArraySaved = NSKeyedUnarchiver.unarchiveObject(with: itemArrayData) as! [Item]
            itemArray = itemArraySaved
        }
    }
    
    @objc func addItemTextChanged(_ sender: UITextField) {
        self.addActionToEnable?.isEnabled = true
    }
    
    // MARK : - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
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
            alertTextField.addTarget(self, action: #selector(self.addItemTextChanged(_:)), for: .editingChanged)
            textField = alertTextField
        }
        
        // Add the item to the list
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text?.trimmingCharacters(in: .whitespaces).isEmpty == false{ // Avoids adding empty strings to the array

                self.itemArray.append(Item(t: textField.text!))
                
                // The code below is required to be able to save an array with custom object
                // i.e. [Item] instead of [String]
                // We have to encode our Item object to a Data object so that it can be saved to UserDefaults
                let itemArrayData = NSKeyedArchiver.archivedData(withRootObject: self.itemArray)
                self.defaults.set(itemArrayData, forKey: self.ITEM_ARRAY_DEFAULT_KEY) // Save the array to the user's phone
                
                self.tableView.reloadData()
            }
        }
        
        // Don't add the item to the list
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        self.addActionToEnable = addAction
        addAction.isEnabled = false // Disable the "Add" button until the user enters a string
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
