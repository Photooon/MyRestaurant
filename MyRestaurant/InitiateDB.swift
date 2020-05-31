//
//  InitiateDB.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/25.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit
import Foundation

class InitDB {
    static func initRestaurant()
    {
        let sqlite = SQLiteManager.sharedInstance
        
        if !sqlite.openDB() {return}
        
        let dropRestSql = "DROP TABLE restaurant"
        if !sqlite.execNoneQuerySQL(sql: dropRestSql) {print("Drop failed")}
        
        //插入餐厅数据
        let createRestSql = "CREATE TABLE IF NOT EXISTS restaurant('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 'name' TEXT, 'distance' FLOAT, 'pic' BLOB);"
        if !sqlite.execNoneQuerySQL(sql: createRestSql) {sqlite.closeDB(); return}
        
        let rest0 = "INSERT INTO restaurant(id, name, distance) VALUES(0, '老爹汉堡店', 2.2);"
        if !sqlite.execNoneQuerySQL(sql: rest0) {print("添加restaurant错误")}
        ImageManager.SaveImage(tableName: "restaurant", id: 0, img: UIImage(named: "老爹汉堡店"))
        
        let rest1 = "INSERT INTO restaurant(id, name, distance) VALUES(1, '密斯冰淇淋', 1.2);"
        if !sqlite.execNoneQuerySQL(sql: rest1) {sqlite.closeDB(); return}
        ImageManager.SaveImage(tableName: "restaurant", id: 1, img: UIImage(named: "密斯冰淇淋"))
        
        let rest2 = "INSERT INTO restaurant(id, name, distance) VALUES(2, '玛格利塔', 2.8);"
        if !sqlite.execNoneQuerySQL(sql: rest2) {sqlite.closeDB(); return}
        ImageManager.SaveImage(tableName: "restaurant", id: 2, img: UIImage(named: "玛格利塔披萨店"))
        
        let rest3 = "INSERT INTO restaurant(id, name, distance) VALUES(3, '薇薇蛋糕店', 0.5);"
        if !sqlite.execNoneQuerySQL(sql: rest3) {sqlite.closeDB(); return}
        ImageManager.SaveImage(tableName: "restaurant", id: 3, img: UIImage(named: "薇薇蛋糕店"))
        
        sqlite.closeDB()
    }
    
    static func initDish()
    {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        
        //let dropDishSql = "DROP TABLE dish"
        //if !sqlite.execNoneQuerySQL(sql: dropDishSql) {sqlite.closeDB(); return}
        
        let createDishSql = "CREATE TABLE IF NOT EXISTS dish('id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 'restId' INTEGER, 'name' TEXT, 'detail' TEXT, 'price' FLOAT, 'pic' BLOB);"
        if !sqlite.execNoneQuerySQL(sql: createDishSql) {sqlite.closeDB(); return}
        
        //插入菜品数据
        //餐厅0
        let dish0 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(0, 0, '迷你汉堡', '美味迷你汉堡，该有的一样不少！', 12.5);"
        if !sqlite.execNoneQuerySQL(sql: dish0) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 0, img: UIImage(named: "迷你汉堡"))
        
        let dish1 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(1, 0, '超级番茄汉堡', '超级非凡嫩滑多汁板烧喷香大块鸡腿爽口生菜秘制酱料芝麻面包松软长型的番茄汉堡！', 22.5);"
        if !sqlite.execNoneQuerySQL(sql: dish1) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 1, img: UIImage(named: "超级番茄汉堡"))
        
        let dish2 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(2, 0, '蔬菜汉堡', '清晨的第一缕阳光,然后是老爹的蔬菜汉堡外加一杯喷香浓郁的奶茶和健康的蜜桃派😄。', 15.0);"
        if !sqlite.execNoneQuerySQL(sql: dish2) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 2, img: UIImage(named: "蔬菜汉堡"))
        
        let dish3 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(3, 0, '薯条', '精、巧、脆！薯于我的滋味！', 7.5);"
        if !sqlite.execNoneQuerySQL(sql: dish3) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 3, img: UIImage(named: "薯条"))
        
        let dish4 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(4, 0, '可乐', '每刻尽可乐，可口可乐！', 5.0);"
        if !sqlite.execNoneQuerySQL(sql: dish4) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 4, img: UIImage(named: "可乐"))
        
        //餐厅1
        let dish5 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(5, 1, '草莓甜心', '冰与火、冷与热、烧热的铁板与雪糕、君度酒与生果、火焰加雪气，一切都配合得天衣无缝。假如现场烹调，作用更佳，而且还能活跃就餐气氛。', 13.5);"
        if !sqlite.execNoneQuerySQL(sql: dish5) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 5, img: UIImage(named: "草莓甜心"))
        
        let dish6 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(6, 1, '彩虹圣代', '彩虹圣代，是对美食艺术最完美的体现，诠释超卓、香、味、型、器之美食文化精华，表现了造型艺术与时髦美味的完美结合，每一个冰淇凌球都令人爱不释手，拍案叫绝！', 12.5);"
        if !sqlite.execNoneQuerySQL(sql: dish6) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 6, img: UIImage(named: "彩虹圣代"))
        
        let dish7 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(7, 1, '花生圣代', '当香浓醇美的巴菲雪糕和亦苦亦甜的巧克力戚风完美结合，我无法用语言来描述那美好的味道，仅仅感觉那份共同的苦甜，亦如一对亲密无间的爱人之间那份可贵的相知与默契，温顺纠缠在唇齿之间，互相信赖，注视，一切尽在不言中。', 8.0);"
        if !sqlite.execNoneQuerySQL(sql: dish7) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 7, img: UIImage(named: "花生圣代"))
        
        let dish8 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(8, 1, '鸡蛋冰淇淋', '暖暖的鸡蛋壳配上凉凉的冰激凌，冰激凌的清凉细腻 和鸡蛋壳的表面松脆、里边疏松，真是绝配！夏秋之交，就该吃它！', 3.5);"
        if !sqlite.execNoneQuerySQL(sql: dish8) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 8, img: UIImage(named: "鸡蛋冰淇淋"))
        
        //餐厅2
        let dish9 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(9, 2, '蔬菜披萨', '新鲜的什锦蔬菜，佐以正宗意大利披萨酱料，味道鲜香之极！进口的芝士环绕其中，让你顷刻领略田园的别样风情！', 33.5);"
        if !sqlite.execNoneQuerySQL(sql: dish9) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 9, img: UIImage(named: "蔬菜披萨"))
        
        let dish10 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(10, 2, '洋葱芝士披萨', '消融的进口芝士掩盖不住豆鼓鲮鱼的香味，洋葱洒落芝士之上，照亮了每一个食客的新房！', 20.0);"
        if !sqlite.execNoneQuerySQL(sql: dish10) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 10, img: UIImage(named: "洋葱芝士披萨"))
        
        let dish11 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(11, 2, '番茄芝士披萨', '番茄成了主角，洋葱丝夹杂其中，似丝罗般密布在培根周围，青红椒丝错落有致，把色、香、味发挥得淋漓尽致！', 21.5);"
        if !sqlite.execNoneQuerySQL(sql: dish11) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 11, img: UIImage(named: "番茄芝士披萨"))
        
        let dish12 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(12, 2, '海盐烤肉披萨', '海盐风味的牛肉均匀地摆在面饼上，周围轻盈飘洒着的些许口蘑片，更是锦上添花，再佐以进口芝士和正宗披萨酱，口味简约但不简单！', 38.5);"
        if !sqlite.execNoneQuerySQL(sql: dish12) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 12, img: UIImage(named: "海盐烤肉披萨"))
        
        //餐厅3
        let dish13 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(13, 3, '草莓小甜心', '草莓入口时嫩滑爽口，香气扑鼻，甜丝丝的奶油毫不滑腻。微微的甜，谁尝了都会忍不住吃上第二口！', 16.5);"
        if !sqlite.execNoneQuerySQL(sql: dish13) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 13, img: UIImage(named: "草莓小甜心"))
        
        let dish14 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(14, 3, '黑森巧克力蛋糕', '香浓诱人的巧克力口味，柔软的口感、甜蜜的味道，完美的黑森蛋糕经得起各种口味的挑剔。表面富有曲线美的巧克力花纹与蛋糕的名称更是相得益彰！', 28.0);"
        if !sqlite.execNoneQuerySQL(sql: dish14) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 14, img: UIImage(named: "黑森巧克力蛋糕"))
        
        let dish15 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(15, 3, '车厘子蛋糕', '勺子轻轻挖下一块带着车厘子和奶油的蛋糕，放入口中，根本不用嚼，含在口中一会儿就化掉了，唇齿间留下一丝淡淡的清香。细细回味，奶油浓浓的气息回旋在口中，甜甜的，香香的。', 23.5);"
        if !sqlite.execNoneQuerySQL(sql: dish15) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 15, img: UIImage(named: "车厘子蛋糕"))
        
        let dish16 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(16, 3, '情人玫瑰蛋糕', '来自大自然的鲜明而清新的粉红色，涂抹在可爱的几朵粉色的玫瑰花上，还有灿烂的蝴蝶轻轻驻足。不是童话，却胜似童话。真漂亮。讨好味觉的艺术得到了淋漓尽致的发挥。', 32.0);"
        if !sqlite.execNoneQuerySQL(sql: dish16) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 16, img: UIImage(named: "情人玫瑰蛋糕"))
        
        let dish17 = "INSERT INTO dish(id, restId, name, detail, price) VALUES(17, 3, '意大利千层蛋糕', '油香浓郁、口感深香有回味，吃在口中香软诱人，自有一种独特风味，令人一品难忘。', 54.0);"
        if !sqlite.execNoneQuerySQL(sql: dish17) {print("添加dish错误")}
        ImageManager.SaveImage(tableName: "dish", id: 17, img: UIImage(named: "意大利千层蛋糕"))
        
        sqlite.closeDB()
    }
}
