//
//  CategoryTableViewController.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-23.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    // MARK: - Constants
    let SEGUE_IDENTIFIER: String = "ShowListSegue"
    let CELL_IDENTIFIER: String = "CategoryCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // Create pointer to our context
    
    // MARK: - Variables
    var categoryArray : [Category] = [Category]()
    weak var addActionToEnable: UIAlertAction?
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    
    // MARK: - Data Model Methods
    func saveData() {
        do {
            try context.save() // Save the data into our DB
        } catch {
            print("Error when trying to save category to database: \(error)")
        }
        
        tableView.reloadData() // Update the UI
    }
    
    func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request) // Load the data from the local database
        } catch {
            print("Error when trying to load database: \(error)")
        }
        
        tableView.reloadData() // Update the UI with the data
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SEGUE_IDENTIFIER, sender: self)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categoryArray[indexPath.row]
            print(categoryArray[indexPath.row].name)
        }
    }
    
    
    
    // MARK: - IB Action Methods
    
    @IBAction func addCategoryButtonPressed(_ sender: Any) {
        var textField: UITextField = UITextField()
        let alertController = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        // This closure is executed now
        alertController.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Enter category name..."
            alertTextField.addTarget(self, action: #selector(self.addCategoryTextChanged(_:)), for: .editingChanged) // Enable Add button when user starts typing
            textField = alertTextField
        }
        
        // User clicks 'Add' button
        let addAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            if textField.text?.trimmingCharacters(in: .whitespaces).isEmpty == false { // Check if the text is empty
                
                // Instantiate a new instance of Category
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text?.trimmingCharacters(in: .whitespaces)
                
                self.categoryArray.append(newCategory) // Add to our tableView
                self.saveData() // Update the UI
            }
        }
        
        // User cancel's addition of new category
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        self.addActionToEnable = addAction
        addAction.isEnabled = false
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func addCategoryTextChanged(_ sender: UITextField) {
        self.addActionToEnable?.isEnabled = true
    }
}
