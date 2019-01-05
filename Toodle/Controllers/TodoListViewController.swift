//
//  TodoListViewController.swift
//  Toodle
//
//  Created by NingX on 12/8/18.
//  Copyright © 2018 ningco. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let encoder = PropertyListEncoder();
    let decoder = PropertyListDecoder();
    
    // declare a new document storage plist for our to-do items and assign it to dataFilePath variable
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
    
        loadItems(decoder)
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
        
        saveItems(encoder)
        
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
            
            self.saveItems(self.encoder)
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "New item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(_ encoder: PropertyListEncoder) {
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!);
        } catch {
            print("Error enc oding item array: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(_ decoder: PropertyListDecoder) {
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error reading existing to do items: \(error)")
            }
        }
    }
    
}

