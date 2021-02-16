//
//  File.swift
//  
//
//  Created by Lonmee on 2/9/21.
//

import Foundation
import PerfectSQLite
import PerfectCRUD
import XCTest

struct Parent: Codable {
    let id: Int
    let children: [Child]?
}

struct Child: Codable {
    let id: Int
    let parentId: Int
}

struct ParentCRUD {
    let dbName = "db/database"
    let db: Database<SQLiteDatabaseConfiguration>
    init() {
        do {
            self.db = Database(configuration: try SQLiteDatabaseConfiguration(dbName))
            try self.db.transaction {
                try db.create(Parent.self, policy: [.shallow, .dropTable]).insert(
                    Parent(id: 1, children: nil))
                try db.create(Child.self, policy: [.shallow, .dropTable]).insert(
                    [Child(id: 1, parentId: 1),
                     Child(id: 2, parentId: 1),
                     Child(id: 3, parentId: 1)])
            }
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func test() throws -> Void {
        let join = try db.table(Parent.self)
            .join(\.children,
                  on: \.id,
                  equals: \.parentId)
            .where(\Parent.id == 2)
        guard let parent = try join.first() else {
            return
        }
        guard let children = parent.children else {
            return
        }
        for child in children {
            print(child)
        }
    }
}
