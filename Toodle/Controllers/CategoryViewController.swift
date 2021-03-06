//
//  CategoryViewController.swift
//  Toodle
//
//  Created by NingX on 1/10/19.
//  Copyright © 2019 ningco. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // local state
    var categories: Results<Category>?
    
    // connect to persistent storage
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Date().timeIntervalSince1970)
        
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView Datasource methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // segue to its own todo item list
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        // if segue.identifier == "goToItems"
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "createdAt", ascending: true)
        
        tableView.reloadData()
    }
    
    // MARK: - Delete data from swipe
    override func updateModel(at: IndexPath) {
        if let toDelete = categories?[at.row] {
            do {
                try realm.write {
                    // make sure to delete child items as well
                    realm.delete(toDelete.items)
                    realm.delete(toDelete)
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // modal that is presented
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // action to be placed on modal
        let action = UIAlertAction(title: "Add Category", style: .default) {
            (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            newCategory.createdAt = Date()
        
            self.save(category: newCategory)
        }
        
        // add text field to action
        alert.addTextField {
            (alertTextField) in
            
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }
        
        // attach action to modal
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

}
