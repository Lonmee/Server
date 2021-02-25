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
    let sex: Bool?
    let age: Int?
    let contact: [Contact]?
}

struct Contact: Codable {
    let uid: UUID
    let phone: String?
    let email: String?
    let qq: String?
    let wechat: String?
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
            try db.create(User.self, primaryKey: \.id, policy: .defaultPolicy)
            
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
    
    func retrieve(_ id: String?) throws -> [User] {
        var data = [User]()
        if let uuid = UUID(uuidString: id ?? "") {
            let query = try userTable.order(by: \.id)
                .join(\.contact, on: \.id, equals: \.uid)
                .where(\User.id == uuid)
                .select()
            data = query.map({ $0 })
        } else {
            let query = try userTable.order(by: \.id)
                .join(\.contact, on: \.id, equals: \.uid)
                .select()
            data = query.map({ $0 })
        }
        return data
    }
    
    func update(_ users: [User]) throws -> [User] {
        let tUsers = users.map { u in
            User(id: u.id, name: u.name, sex: u.sex, age: u.age, contact: nil)
        }
        let cUsers = users.map { u in
            u.contact
        }
        try db.transaction {
            for u in tUsers {
                try userTable.order(by: \User.id)
                    .where(\User.id == u.id)
                    .update(u, ignoreKeys: \.id)
                try contactTable.order(by: \.uid)
                    .where(\Contact.uid == u.id)
                    .delete()
            }
            for cs in cUsers {
                if (cs != nil && cs!.count > 0) {
                    try contactTable.insert(cs!)
                }
            }
        }
        return users
    }
    
    func delete(_ id: String?) throws -> [User] {
        if let uuid = UUID(uuidString: id ?? "") {
            let uQuery = userTable.where(\User.id == uuid)
            let cQuery = contactTable.where(\Contact.uid == uuid)
            try uQuery.delete()
            try cQuery.delete()
        } else {
            throw NoParaError("no id no action")
        }
        return [User]()
    }
}

struct NoParaError: CustomNSError {
    var errorCode: Int = 800
    var errorUserInfo: [String : Any] = ["reason": "no id no action"]
    init(_ reason: String) {
    }
}
