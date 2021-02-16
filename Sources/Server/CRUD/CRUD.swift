//
//  File.swift
//  
//
//  Created by Lonmee on 2/16/21.
//

import Foundation

protocol CRUD {
    associatedtype ItemType: Codable
    func create(_ id: String?) -> Void
    func retrieve(_ id: String?) -> [ItemType]
    func update(_ id: String?) -> Void
    func delete(_ id: String?) -> Void
}
