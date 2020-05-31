//
//  ImageManager.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import Foundation

import UIKit

class ImageManager {
    static func SaveImage(tableName: String, id: Int, img: UIImage?) {          //更新选中表的某一项的图片
        if img == nil {
            return
        }
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {
            return
        }
        
        let sql = "UPDATE \(tableName) SET pic = ? WHERE id = \(id)"
        let data = img!.jpegData(compressionQuality: 1.0) as NSData?
        sqlite.execSaveBlob(sql: sql, blob: data!)
        
        sqlite.closeDB()
        return
    }
    
    static func LoadImage(tableName: String, id: Int) -> UIImage {                                 //取选中表中的某一项的图片
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {
            return UIImage(named: "no picture")!
        }
        let sql = "SELECT pic FROM \(tableName) where id = \(id)"
        let data = sqlite.execLoadBlob(sql: sql)
        sqlite.closeDB()
        if data != nil {
            return UIImage(data: data!)!
        } else {
            return UIImage(named: "no picture")!
        }
    }
    
    static func LoadImage(tableName: String, userName: String) -> UIImage {                         //取选中表中的某一项的图片
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {
            return UIImage(named: "userPic")!
        }
        let sql = "SELECT pic FROM \(tableName) where name='\(userName)'"
        let data = sqlite.execLoadBlob(sql: sql)
        sqlite.closeDB()
        if data != nil {
            return UIImage(data: data!)!
        } else {
            return UIImage(named: "userPic")!
        }
    }
}
