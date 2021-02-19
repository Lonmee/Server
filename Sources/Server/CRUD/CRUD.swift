//
//  File.swift
//  
//
//  Created by Lonmee on 2/16/21.
//

import Foundation

protocol CRUD {
    associatedtype ItemType: Codable
    func create(_ users: [ItemType]) throws -> [ItemType]
    func retrieve(_ id: String?) throws -> [ItemType]
    func update(_ id: String?) throws -> [ItemType]
    func delete(_ id: String?) throws -> [ItemType]
}
