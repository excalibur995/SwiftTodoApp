//
//  TodoItem.swift
//  TodoApp
//
//  Created by raihanalbazzy on 06/02/21.
//

import Foundation

struct TodoItem:Encodable, Decodable {
    var title:String = ""
    var done:Bool = false
}
