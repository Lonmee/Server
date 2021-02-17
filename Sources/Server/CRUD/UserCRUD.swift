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
    let id: UUID
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
            try db.create(User.self, policy: .defaultPolicy)
            
            self.userTable = db.table(User.self)
            self.contactTable = db.table(Contact.self)
            
            // test only
            //poplate()
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func create(_ id: String?) {
        print("create")
    }
    
    func retrieve(_ id: String?) -> [User] {
        var data = [User]()
        do {
            let query = try userTable.order(by: \.id)
                .join(\.contact, on: \.id, equals: \.id)
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
    
    func update(_ id: String? = "") -> Void {
        print("update")
    }
    
    func delete(_ id: String? = "") -> Void {
        print("delete")
    }
    
    func poplate() -> Void {
        do {
            try contactTable.index(\.id)
            let a = User(id: UUID(), name: "Lonmee", sex: true, age: 39, contact: nil)
            let b = User(id: UUID(), name: "She", sex: false, age: 38, contact: nil)
            let c = User(id: UUID(), name: "Lunar", sex: false, age: 38, contact: nil)
            
            try userTable.insert([a, b, c])
            try contactTable.insert([
                Contact(id: a.id, phone: "13811005415", email: "lonmee@126.com", qq: "25824892", wechat: "25824892"),
                Contact(id: b.id, phone: "13426431514", email: "WSX_hz@126.com", qq: "25824892", wechat: "25824892"),
                Contact(id: c.id, phone: "13426431514", email: "lunar@126.com", qq: "25824892", wechat: "25824892"),
            ])
        } catch {
            print(error)
        }
    }
}
