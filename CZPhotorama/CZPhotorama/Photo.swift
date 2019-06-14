//
//  Photo.swift
//  CZPhotorama
//
//  Created by ChenZhen on 2019/6/13.
//  Copyright © 2019 ChenZhen. All rights reserved.
//

import Foundation

class Photo {
    let title: String
    let remoteUrl: URL
    let photoId: String
    let dateTaken: Date
    
    init(title: String, photoId: String, remoteUrl: URL, dateTaken: Date) {
        self.title = title
        self.photoId = photoId
        self.remoteUrl = remoteUrl
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoId == rhs.photoId
    }
}
