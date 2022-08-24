//
//  Category.swift
//  ToDoList_Udemy
//
//  Created by Ekko on 2022/08/17.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    
    let items = List<Item>()
    
}
