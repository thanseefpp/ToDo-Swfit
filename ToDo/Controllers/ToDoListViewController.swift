//
//  ToDoListTableViewController.swift
//  ToDo
//
//  Created by THANSEEF on 03/03/22.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet var tabelView: UITableView!
    
    //localstorage handle
    var itemArray = [TodoModel]()
    
    //MARK: - Coredata handling initialised db
    // downcating shared delegate to app delegate.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // creating a plist to handle local storage datas
    //    let dataFilesPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    // creating an object to userdefault database.
    //    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //to fetch all the items in database.
        loadItems()
        
        //        var newItem = ToDoModel()
        //        newItem.items = "first Todo task"
        //        newItem.isChecked = true
        //        itemArray.append(newItem)
        //
        //        var newItem2 = ToDoModel()
        //        newItem2.items = "second Todo task"
        //        itemArray.append(newItem2)
        //
        //        var newItem3 = ToDoModel()
        //        newItem3.items = "third Todo task"
        //        itemArray.append(newItem3)
        
        
        //persist local storage data.
        //        if let items = defaults.array(forKey: "TodoListArray") as? [ToDoModel] {
        //            itemArray = items
        //        }
    }
    
    //MARK: - Table view Datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let arrayData = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.items
        
        //Ternary operator
        //assigne value = condition ? expression1 : expression2
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        //        if item.isChecked == true {
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArray[indexPath.row])
        
        //toupdate a field
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        // and call save item.
        
        /*to delete item in sqllite (coredata) don't call itemarray first call context then call item array remove otherwise it will show some error */
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        // checkmark/uncheck the items checking in a sinlge line
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        
        self.saveItems()
        
        // animation for deselecting items
        tabelView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add items button section
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        // created a local variable to store the items from alert box
        var textField = UITextField()
        
        // here creating a alert controll view to triger
        let alert = UIAlertController(title: "Add New Task", message: "Item added to ToDo List ", preferredStyle: .alert)
        
        // action to the alert view
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //this place only execute when the user press the add item button
            
            let newItems = TodoModel(context: self.context)
            //            var newItems = ToDoModel() // 2nd method to hanlde codable format
            newItems.items = textField.text!
            newItems.isChecked = false
            self.itemArray.append(newItems)
            
            // calling the function to run the encode method to store data to plist
            self.saveItems()
            
            //creating a default set to add items to it.
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // here is assiging alerttextfield user added data to the variable.
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        // to show the aler message with animation.
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Encoding
    
    func saveItems(){
        
        //MARK: - codable method to keep local storage items.
        //object that encodes instances of data types to a property list.
        //        let encode = PropertyListEncoder()
        //using do catch to avoid error
        
        do{
            // local storage codable method.
            // let data = try encode.encode(itemArray)
            // try data.write(to: dataFilesPath!)
            
            // saving the context
            try self.context.save()
            
        }catch{
            print("Error occured during contextsaving \(error)")
        }
        // to reload the tableview
        self.tabelView.reloadData()
    }
    
    
    //setting a defautl value to the parameter to avoid the conflict when the function call without argument it will be executed.
    func loadItems(with request : NSFetchRequest<TodoModel> = TodoModel.fetchRequest()) {
        //MARK: - decoding
        //        if let data = try? Data(contentsOf: dataFilesPath!) {
        //            let decorder = PropertyListDecoder()
        //            do{
        //                itemArray = try decorder.decode([ToDoModel].self, from: data)
        //            }catch{
        //                print("Error occured while decoding item array \(error)")
        //            }
        //        }
        
        //MARK: - coredata sqlite fetching items ( read )
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error occured during fetching items \(error)")
        }
        
        //to reload the data.
        tabelView.reloadData()
    }
}


//MARK: - Search bar method

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // created a varibale contain request from the coredata table.
        let request : NSFetchRequest<TodoModel> = TodoModel.fetchRequest()
        
        //predict variable will take the values inserted in searchbox. here checking the search text field value with title contains.
        request.predicate = NSPredicate(format: "items CONTAINS[cd] %@", searchBar.text!)
        
        // here sorting the searched items based on our table field. ascending order. must use array
        request.sortDescriptors = [NSSortDescriptor(key: "items", ascending: true)]
        
        loadItems(with: request)
    }
    
    // this delegate method will always trigger when the user type text or remove from searchbar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // to dismiss the keyboard
            //using dispathchqueue to run thread as main.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}


