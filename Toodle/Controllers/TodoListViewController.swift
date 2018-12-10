//
//  TodoListViewController.swift
//  Toodle
//
//  Created by NingX on 12/8/18.
//  Copyright © 2018 ningco. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let item1 = Item("Buy eggs")
        let item2 = Item("Buy more eggs")
        let item3 = Item("Buy eggs again")
        
        itemArray.append(item1)
        itemArray.append(item2)
        itemArray.append(item3)
        
        if let items = defaults.array(forKey: "ItemArray") as? [Item] {
            itemArray = items
        }
    }
    
    //MARK - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // this is modal that is presented
        let alert = UIAlertController(title: "Add New Item",
                                      message: "",
                                      preferredStyle: .alert)
        
        // this is the action to be on the modal
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            
            // what happens once the user clicks the Add Item button on the alert modal
            self.itemArray.append(Item(textField.text!))
            
            self.defaults.set(self.itemArray, forKey: "ItemArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

