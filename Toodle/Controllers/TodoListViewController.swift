//
//  TodoListViewController.swift
//  Toodle
//
//  Created by NingX on 12/8/18.
//  Copyright © 2018 ningco. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory!.name
        
        guard let colorHex = selectedCategory?.color else {
            fatalError("No selectedCategory")
        }
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Nav Bar setup methods
    
    func updateNavBar(withHexCode colorHexCode: String) {

        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else {
            fatalError("No selectedCategory color")
        }
        
        navBar.barTintColor = navBarColor
        searchBar.barTintColor = navBarColor
        
        let contrastColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.tintColor = contrastColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
    }
    
    //MARK - tableview datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = todoItems?[indexPath.row].title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let cellColor = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = cellColor
                cell.textLabel?.textColor = ContrastColorOf(cellColor, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    // updates item
                    selectedItem.done = !selectedItem.done
                }
            } catch {
                print("Error toggling and saving done status: \(error)")
            }
        }
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.createdAt = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving newly added item: \(error)")
                }
            }
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
    

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "createdAt", ascending: true)
        tableView.reloadData()
    }
    
     // MARK: - Delete items on swipe
    override func updateModel(at: IndexPath) {
        if let toDelete = todoItems?[at.row] {
            do {
                try realm.write{
                    realm.delete(toDelete)
                }
            } catch {
                print("Error deleting To-do item \(toDelete.title) : \(error)")
            }
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "createdAt", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

