//
//  File.swift
//  
//
//  Created by Lonmee on 2/8/21.
//

import Foundation
import PerfectSQLite
import PerfectCRUD

struct User: Codable {
    let id: UUID
    let name: String
    let sex: Bool
    let age: Int
    let contact: [Contact]?
}

struct Contact: Codable {
    let uid: UUID
    let phone: String
    let email: String
    let qq: String
    let wechat: String
}

struct UserCRUD: CRUD {
    typealias ItemType = User
    let dbName = "db/database"
    let db: Database<SQLiteDatabaseConfiguration>
    
    let userTable: Table<User, Database<SQLiteDatabaseConfiguration>>
    let contactTable: Table<Contact, Database<SQLiteDatabaseConfiguration>>
    
    init() {
        do {
            self.db = Database(configuration: try SQLiteDatabaseConfiguration(dbName))
            try db.create(User.self, primaryKey: \.id, policy: .dropTable)
            
            self.userTable = db.table(User.self)
            self.contactTable = db.table(Contact.self)
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func create(_ users: [User]) throws -> [User] {
        let tUsers = users.map { u in
            User(id: u.id, name: u.name, sex: u.sex, age: u.age, contact: nil)
        }
        let cUsers = users.map { u in
            u.contact
        }
        try userTable.insert(tUsers)
        for cs in cUsers {
            try contactTable.insert(cs!)
        }
        return users
    }
    
    func retrieve(_ id: String?) -> [User] {
        var data = [User]()
        do {
            let query = try userTable.order(by: \.id)
                .join(\.contact, on: \.id, equals: \.uid)
                .where(id == nil || id == "/" ?
                        \User.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000")! :
                        \User.id == UUID(uuidString: id!)!)
                .select()
            
            for user in query {
                data.append(user)
            }
        } catch {
            print(error)
        }
        return data
    }
    
    func update(_ id: String? = "") -> [User] {
        print("update")
        return [User]()
    }
    
    func delete(_ id: String? = "") -> [User] {
        print("delete")
        return [User]()
    }
}
