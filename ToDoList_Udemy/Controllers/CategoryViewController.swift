//
//  CategoryViewController.swift
//  ToDoList_Udemy
//
//  Created by Ekko on 2022/08/16.
//
//

//  CategoryViewController.swift

//  ToDoList_Udemy

//

//  Created by Ekko on 2022/08/16.

//

import UIKit

import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [ToDoCategory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    //MARK: - TableView Datasource Methods**
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulate Methods
    func saveCategories() {
        
        do {
            try context.save()
            print("saveCategories")
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()
        
        do {
            categories = try context.fetch(request)
            print("loadCategories")
        } catch {
            print("Error loading categories \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = ToDoCategory(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
        textField = field
        textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true,completion: nil)
    }
    
}
