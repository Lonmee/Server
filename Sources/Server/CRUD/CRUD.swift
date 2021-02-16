//
//  File.swift
//  
//
//  Created by Lonmee on 2/16/21.
//

import Foundation

protocol CRUD {
    func create(_ id: String?) -> Void
    func retrieve(_ id: String?) -> [User]
    func update(_ id: String?) -> Void
    func delete(_ id: String?) -> Void
}
