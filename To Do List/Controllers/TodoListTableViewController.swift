//
//  TodoListTableViewController.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-22.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewController: SwipeTableViewController {
    
    // MARK: - Constants
    let CELL_IDENTIFIER: String = "ToDoItemCell"
    let realm = try! Realm()
    
    // MARK: - Variables
    var todoItems : Results<Item>?
    weak var addActionToEnable: UIAlertAction?
    // Call loadData() once this variable has a value
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    // MARK: - IB Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.title = selectedCategory?.name
    }
    
    // This method is called when we detect that the user started typing in a new list item
    @objc func addItemTextChanged(_ sender: UITextField) {
        self.addActionToEnable?.isEnabled = true
    }
    
    
    // MARK : - Save/Load Data Methods
    func loadData() {
        todoItems = realm.objects(Item.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data Model
    override func updateModel(at indexPath: IndexPath) {
        if let deleteItem = self.todoItems?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(deleteItem)
                }
            } catch {
                print("Error when trying to delete Category: \(error)")
            }
        }
    }
    
    // MARK : - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none // Set the checkmark of the cell
        } else {
            cell.textLabel!.text = "No Items In To Do List"
        }
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check off/on the item in the list
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.checked = !item.checked
                }
            } catch {
                print("Error trying to save checked status to Realm: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    
    // MARK: - IB Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField() // Created to have access to the variable when the closure executes
        let alertController = UIAlertController(title: "Add item to list", message: "", preferredStyle: .alert)
        
        // This closure is executed now
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter item..."
            alertTextField.addTarget(self, action: #selector(self.addItemTextChanged(_:)), for: .editingChanged) // Listens for when the user types
            textField = alertTextField // Need a reference to this local variable so that we can access it after this closure executes
        }
        
        // User clicked the 'Add' button
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text?.trimmingCharacters(in: .whitespaces).isEmpty == false{ // Check if the string the user entered isn't just spaces or empty
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item() // Create an instance of our Item entity
                            newItem.title = (textField.text?.trimmingCharacters(in: .whitespaces))!
                            newItem.dateCreated = Date()
                            self.realm.add(newItem)
                        }                   // Save the data into our Realm DB
                    } catch {
                        print("Error saving context: \(error)")
                    }
                    
                    
                    self.tableView.reloadData()
                }
            }
        }
        
        // Add a cancel button that does nothing when the user clicks it
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        self.addActionToEnable = addAction
        addAction.isEnabled = false // Disable the "Add" button until the user enters a string
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}



// MARK: - Search Bar Methods
extension TodoListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty == false {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!.trimmingCharacters(in: .whitespaces)).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Everytime the search bar is editied, perform the operations below

        if searchBar.text?.count == 0 {
            loadData()
        }
    }
}
