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
    let contact: Contact?
}

struct Contact: Codable {
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
            try db.create(User.self, policy: .dropTable)
            
            self.userTable = db.table(User.self)
            self.contactTable = db.table(Contact.self)
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func create(_ users: [User]) throws -> [User] {
//        try contactTable.index(\.id)
//        try userTable.insert(users, setKeys: .id, .name, .sex, .age)
//        try contactTable.insert(users, setKeys: .id, .phone, .email, .qq, .wechat)
        return users
    }
    
    func retrieve(_ id: String?) -> [User] {
        var data = [User]()
        do {
            let query = try userTable.order(by: \.id)
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
