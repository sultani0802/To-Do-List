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
    let CELL_IDENTIFIER: String = "ToDoItemCell"
    // For plist files:
    // If we wanted to create a different plist that stores our data (for example, creating a plist for a to do list for your work
    // We would create another dataFilePath with a different string as the parameter
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // Address to our plist file that will hold our local data
    
    // MARK: - Variables
    var itemArray : [Item] = [Item]()
    weak var addActionToEnable: UIAlertAction?
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    @objc func addItemTextChanged(_ sender: UITextField) {
        self.addActionToEnable?.isEnabled = true
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
    }
    
    
    func loadData() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }

    }
    // MARK : - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.checked ? .checkmark : .none // Set the checkmark of the cell
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check off/on the item in the list
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        saveData()
        
        tableView.reloadData()
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

                self.itemArray.append(Item(t: textField.text!, c: false))
                self.saveData()
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
