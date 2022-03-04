//
//  ToDoModel.swift
//  ToDo
//
//  Created by THANSEEF on 03/03/22.
//

import Foundation

// using codable to work decodable,encodable.
struct ToDoModel : Codable {
    var items : String = ""
    var isChecked : Bool = false
}
