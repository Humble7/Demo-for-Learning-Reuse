//
//  main.swift
//  WritingToFileSystemWithSerialization
//
//  Created by ChenZhen on 2019/6/9.
//  Copyright © 2019 ChenZhen. All rights reserved.
//

import Foundation

/*
 * 如果某个属性的类可被序列化，这个属性就可以直接被写入文件系统
 * 写入文件时，系统会为其创建一段XML格式的数据
 */

let itemSerializationURL: URL = {
    let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentsDirectories.first!
    return documentDirectory.appendingPathComponent("items.archive")
}()

let authors: AnyObject = [
    ["firstName":"Chen", "lastName":"Mo"],
    ["firstName":"Zhao", "lastName":"Mo"]
    ] as AnyObject

func serialize() {
    let authors: AnyObject = [
        ["firstName":"Chen", "lastName":"Mo"],
        ["firstName":"Zhao", "lastName":"Mo"]
        ] as AnyObject
    
    if PropertyListSerialization.propertyList(authors, isValidFor: .xml) {
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: authors, format: .xml, options:0)
            
            do {
                try data.write(to: itemSerializationURL, options: [.atomic])
                print("Success to write:\(itemSerializationURL.path)")
            } catch {
                print("Error writing:\(error)")
            }
        } catch {
            print("Error writing plist:\(error)")
        }
    }
}

func deSerialize() {
    do {
        guard let data = try? Data(contentsOf: itemSerializationURL, options: []) else { return }
        let authors = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        print("\n\nSucces to read\(authors)")
    } catch {
        print("Error: \(error)")
    }
    
}

// 写入文件
serialize()

// 读取文件
deSerialize()
