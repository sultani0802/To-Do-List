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
            print("Error when trying to save to database: \(error)")
        }
        
        tableView.reloadData() // Update the UI
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request) // Load the data from the local database
        } catch {
            print("Error when trying to load database: \(error)")
        }
        
        tableView.reloadData() // Update the UI with the data
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - IB Action Methods
    
    @IBAction func addCategoryButtonPressed(_ sender: Any) {
    }
}
