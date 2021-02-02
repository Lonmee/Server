//
//  File.swift
//  
//
//  Created by Lonmee on 2/3/21.
//

import PerfectSQLite

let DB_PATH = "./db/database"
var contentDict = [String: Any]()
var page = 0

func createTable() -> Void {
    do {
        let sqlite = try SQLite(DB_PATH)
        defer {
            sqlite.close()
        }
        try sqlite.execute(statement: "CREATE TABLE IF NOT EXISTS demo (id INTEGER PRIMARY KEY NOT NULL, option TEXT NOT NULL, value TEXT)")
    } catch {
        print(error)
    }
}

func loadPageContent(forPage: Int) {
    do {
        let sqlite = try SQLite(DB_PATH)
        defer {
            sqlite.close()
        }
        let sqlStatement = "SELECT post_content, post_title FROM posts ORDER BY id DESC LIMIT 5 OFFSET :1"
        
        try sqlite.forEachRow(statement: sqlStatement, doBindings: {
            (statement: SQLiteStmt) -> () in
            
            let bindPage: Int
            if page == 0 || page == 1 {
                bindPage = 0
            } else {
                bindPage = forPage * 5 - 5
            }
            
            try statement.bind(position: 1, bindPage)
        }) {
            (statement: SQLiteStmt, i:Int) -> () in
            contentDict.merge([
                "postContent": statement.columnText(position: 0),
                "postTitle": statement.columnText(position: 1)
            ]) { (_, new) in new }
        }
    } catch {
        print(error)
    }
}
