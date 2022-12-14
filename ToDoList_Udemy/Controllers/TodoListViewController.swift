//
//  ViewController.swift
//  ToDoList_Udemy
//
//  Created by Ekko on 2022/08/12.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwiftUI

class TodoListViewController: SwipeViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colourHex =
            selectedCategory?.colour {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation Controller does not exist.")}
            
            if let navBarColour = UIColor(hexString: colourHex) {
                navBar.barTintColor = navBarColour
                navBar.backgroundColor = navBarColour
                
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                
                searchBar.barTintColor = navBarColour
            }
            
            
        }
    }

    //MARK: TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]  {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat( todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            
            
            // ternary operator ==>
            // value = condition ? valueIfTrue: valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark: .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }

    //MARK: TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status. \(error)")
            }
            
        }
        tableView.reloadData()
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
//        todoItems[indexPath.row].done = !itemArray[indexPath.row].done
//
//        saveItems()

        // cell ????????? ???????????? ?????????.
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model Manupulation Methods
    

    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }
}

//MARK: - Search Bar Method

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
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
