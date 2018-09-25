//
//  CategoryTableViewController.swift
//  To Do List
//
//  Created by Haamed Sultani on 2018-09-23.
//  Copyright © 2018 Sultani. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    // MARK: - Constants
    let SEGUE_IDENTIFIER: String = "ShowListSegue"
    let CELL_IDENTIFIER: String = "CategoryCell"
    let realm = try! Realm()
    
    // MARK: - Variables
    var categoryArray : Results<Category>?
    weak var addActionToEnable: UIAlertAction?
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black // Change the 'Back' bar button item color to white
    }
    
    
    // MARK: - Data Model Methods
    func saveData(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }                          // Save the data into our Realm DB
        } catch {
            print("Error when trying to save category to database: \(error)")
        }
        
        tableView.reloadData() // Update the UI
    }
    
    func loadData(){
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData() // Update the UI with the data
    }
    
    //MARK: - Delete Data Model
    override func updateModel(at indexPath: IndexPath) {
        if let deleteCategory = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(deleteCategory)
                }
            } catch {
                print("Error when trying to delete Category: \(error)")
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
        }
        
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
            destVC.selectedCategory = categoryArray?[indexPath.row]
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
                let newCategory = Category()
                newCategory.name = (textField.text?.trimmingCharacters(in: .whitespaces))!
                
                self.saveData(category: newCategory) // Update the UI
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
