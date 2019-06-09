//
//  Item.swift
//  FileRW
//
//  Created by ChenZhen on 2019/6/9.
//  Copyright © 2019 ChenZhen. All rights reserved.
//

import Foundation

class Item: NSObject, NSCoding { // 需要Archive的对象必须遵循NSCoding协议，并实现其中的方法
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = NSUUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
        aCoder.encode(serialNumber, forKey: "serialNumber")
        aCoder.encode(dateCreated, forKey: "dateCreated")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        serialNumber = aDecoder.decodeObject(forKey: "serialNumber") as! String?
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! Date
    }
}
