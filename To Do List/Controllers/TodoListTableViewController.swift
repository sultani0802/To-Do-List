//
//  TodoListTableViewController.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-22.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {
    
    // MARK: - Constants
    let CELL_IDENTIFIER: String = "ToDoItemCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Get access to our context
    
    
    // MARK: - Variables
    var itemArray : [Item] = [Item]()
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
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(context)")
        }
        tableView.reloadData()
    }
    
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // Go into database and get a reference to the Category we want we want with any additional predicates
        // If we don't pass in an NSFetchRequest,
        // If we don't pass in a predicate, then fetch all the items in the category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let pred = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, pred])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request) // Try and get that data from the context
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
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
                
                let newItem = Item(context: self.context) // Create an instance of our Item entity in our Data Model
                newItem.title = textField.text! // Must instantiate the properties because we declared that it can't be optional in our Data Base
                newItem.checked = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem) // Add the new Item to our array
                
                self.saveData()
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
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!.trimmingCharacters(in: .whitespaces)) // Search for substrings that aren't case and diacratic sensitive and remove any extra spaces
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // Sort in alphabetical order based on the item's title
            
            request.predicate = predicate
            request.sortDescriptors = [sortDescriptor]
            
            loadData(with: request, predicate: predicate)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Everytime the search bar is editied, perform the operations below
        
        if searchBar.text?.count == 0 {
            loadData()
        }
    }
}
