//
//  SQLite.swift
//  P0902
//
//  Created by 邹龙威 on 2020/3/30.
//  Copyright © 2020 WHU. All rights reserved.
//

import Foundation

class SQLiteManager:NSObject {
    private var dbPath: String!
    private var database: OpaquePointer? = nil
    
    static var sharedInstance: SQLiteManager
    {
        return SQLiteManager()
    }
    
    override init() {
        super.init()
        
        let dirpath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        dbPath = dirpath.appendingPathComponent("app.sqlite").path
    }
    
    //打开数据库
    func openDB() -> Bool {
        let result = sqlite3_open(dbPath, &database)
        if result != SQLITE_OK {
            print("fail to open database")
            return false
        }
        return true
    }
    
    //关闭数据库
    func closeDB() {
        sqlite3_close(database)
    }
    
    //执行: create, insert, update, delete
    func execNoneQuerySQL(sql: String) -> Bool {
        
        var errMsg: UnsafeMutablePointer<Int8>? = nil
        let cSql = sql.cString(using: String.Encoding.utf8)
        
        if sqlite3_exec(database, cSql, nil, nil, &errMsg) == SQLITE_OK {
            return true
        }
        let msg = String.init(cString: errMsg!)
        print(msg)
        return false
    }
    
    //执行: select
    func execQuerySQL(sql: String) -> [[String: AnyObject]]? {
        let cSql = sql.cString(using: String.Encoding.utf8)!
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(database, cSql, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            print("执行\(sql)错误\n")
            let errmsg = sqlite3_errmsg(database)
            if errmsg != nil {
                print(errmsg!)
            }
            return nil
        }
        
        var rows = [[String: AnyObject]]()
        while sqlite3_step(statement) == SQLITE_ROW {
            rows.append(record(stmt: statement!))
        }
        sqlite3_finalize(statement)
        return rows
    }
    
    private func record(stmt: OpaquePointer) -> [String: AnyObject] {
        var row = [String: AnyObject]()
        
        for col in 0 ..< sqlite3_column_count(stmt) {
            let cName = sqlite3_column_name(stmt, col)
            let name = String(cString: cName!, encoding: String.Encoding.utf8)
            
            var value: AnyObject?
            
            switch(sqlite3_column_type(stmt, col)) {
            case SQLITE_FLOAT:
                value = sqlite3_column_double(stmt, col) as AnyObject
            case SQLITE_INTEGER:
                value = Int(sqlite3_column_int(stmt, col)) as AnyObject
            case SQLITE_TEXT:
                let cText = sqlite3_column_text(stmt, col)
                value = String.init(cString: cText!) as AnyObject
            case SQLITE_NULL:
                value = NSNull()
            default:
                break
                //print("不支持的数据类型")
            }
            row[name!] = value ?? NSNull()
        }
        
        return row
    }
    
    //保存图片
    func execSaveBlob(sql: String, blob: NSData) {
        let csql = sql.cString(using: .utf8)!
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare(database, csql, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            print("Prepare error:\(sql)")
            return
        }
        
        let paramsCnt = sqlite3_bind_parameter_count(statement)
        if paramsCnt != 1 {
            print("need only 1 parameter:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        
        if sqlite3_bind_blob(statement, 1, blob.bytes, Int32(blob.length), nil) != SQLITE_OK {
            print("bind blob error:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        
        let rslt = sqlite3_step(statement)
        if rslt != SQLITE_OK && rslt != SQLITE_DONE {
            print("extub blob error:\(sql)")
            sqlite3_finalize(statement)
            return
        }
        sqlite3_finalize(statement)
        return
    }
    
    //加载图片
    func execLoadBlob(sql: String) -> Data? {
        let csql = sql.cString(using: String.Encoding.utf8)!
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, csql, -1, &statement, nil) != SQLITE_OK {
            sqlite3_finalize(statement)
            print("执行\(sql)错误\n")
            if let errmsg = sqlite3_errmsg(database) {
                print(errmsg)
            }
            return nil
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            if let dataBlob = sqlite3_column_blob(statement, 0) {
                let dataBlobLength = sqlite3_column_bytes(statement, 0)
                let data = Data(bytes: dataBlob, count: Int(dataBlobLength))
                sqlite3_finalize(statement)
                return data
            }
        }
        sqlite3_finalize(statement)
        return nil
    }
}
