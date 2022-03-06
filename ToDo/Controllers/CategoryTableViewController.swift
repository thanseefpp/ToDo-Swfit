//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by THANSEEF on 06/03/22.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    
    //db initialised category varible as array datatype.
    var categoryField = [Category]()
    // context variabel created to hold persistent container.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //calling nsmodel fetcher.
        loadCategory()
    }
    
    //MARK: - TableView DataSource Methods
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryField.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
//        let categoryItem = categoryField[indexPath.row]
        // Configure the cell’s contents.
        cell.textLabel?.text = categoryField[indexPath.row].name
        
        return cell
    }
    
    //MARK: - add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //created a variable to store data from alertbox
        var alertTextField = UITextField()
        
        //alert triger
        let alert = UIAlertController(title: "Add Category", message: "Add new category for items", preferredStyle: .alert)
        
        //alert box action
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //this place only execute when the user press the add item button
            
            let newCategory = Category(context: self.context)
            newCategory.name = alertTextField.text!
            self.categoryField.append(newCategory)
            
            self.saveItems()
        }
        //action
        alert.addAction(action)
        
        //place holder to the text box inside the alertbox.
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "create new category"
            alertTextField = addTextField
        }
        
        // to show the aler message with animation.
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Delegate Methods
    
    //selected rows will trigger
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //this method is used to go next segue by the identifier name.
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //destination downcasting.
        let destinationVC = segue.destination as! ToDoListViewController
        
        //created a optional binding indexpath to get the selected row
        if let indexPath = tableView.indexPathForSelectedRow {
            //assigning selected category to a category field value.
            destinationVC.selectedCategory = categoryField[indexPath.row]
//            print(destinationVC)
        }
        
    }
    
    
    
    //MARK: - Data Manipulation
    
    func saveItems() {
        do {
            try context.save()
        }catch{
            print("Error occured while saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryField = try context.fetch(request)
        } catch {
            print("Error during fetching category items \(error)")
        }
        tableView.reloadData()
    }
    
    
}
