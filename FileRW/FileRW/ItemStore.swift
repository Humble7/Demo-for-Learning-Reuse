//
//  ItemStore.swift
//  FileRW
//
//  Created by ChenZhen on 2019/6/9.
//  Copyright © 2019 ChenZhen. All rights reserved.
//

import Foundation

class ItemStore {
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    // Unarchive
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: itemArchiveURL.path) as? [Item]{
            allItems = archivedItems
        }
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    /*
     * archiveRootObject(_:toFile:)首先会创建一个NSKeyedArchiver对象
     * NSKeyedArchiver对象是抽象类NScoder的具体子类实现
     * archiveRootObject(_:toFile:)会向allItems发送encode(with:)消息，并传入NSKeyedArchiver对象作为参数
     * allItems的encode(with:)方法会向其包含的所有Item对象发送encode(with:)消息，并传入同一个NSKeyedArchiver对象
     * 这些Item对象会将其属性编码至同一个NSKeyedArchiverc对象
     * 当所有的对象都完成编码后，NSKeyedArchiver对象就会将数据写入指定的文件
     */
    @discardableResult func save() -> Bool {
        print("Saving items to:\(itemArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }
}
