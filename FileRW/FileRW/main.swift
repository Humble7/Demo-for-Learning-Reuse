//
//  main.swift
//  FileRW
//
//  Created by ChenZhen on 2019/6/9.
//  Copyright © 2019 ChenZhen. All rights reserved.
//

import Foundation

let itemStore = ItemStore()

itemStore.createItem()

// 执行Archive
itemStore.save()
