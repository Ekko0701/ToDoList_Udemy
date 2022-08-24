//
//  SwipeViewController.swift
//  ToDoList_Udemy
//
//  Created by Ekko on 2022/08/24.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
    }

    // TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Category와 Item Cell 모두에 적용할 SuperClass이기 때문에 identifier를 Cell로 바꿔주었다. StoryBoard도 마찬가지
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath) // 삭제하는 Cell의 IndexPath를 전달 (subclass에서 재정의된 updateModel을 호출한다.

        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update our Data Model
        print("Item deleted from superclass")
    }
    
}
