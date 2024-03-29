//
//  FlickrAPI.swift
//  CZPhotorama
//
//  Created by ChenZhen on 2019/6/13.
//  Copyright © 2019 ChenZhen. All rights reserved.
//

import Foundation

enum FlickrError: Error {
    case invalidJsonData
}

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrApi {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    static var interestingPhotosUrl: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["extras":"url_h, date_taken"])
    }
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else {
                    return.failure(FlickrError.invalidJsonData)
            }
            var finalPhoto = [Photo]()
            for photoJson in photosArray {
                if let photo = photo(fromJson: photoJson) {
                    finalPhoto.append(photo)
                }
            }
            
            if finalPhoto.isEmpty && !photosArray.isEmpty {
                return .failure(FlickrError.invalidJsonData)
            }
            return .success(finalPhoto)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func photo(fromJson json: [String : Any]) -> Photo? {
        guard
            let photoId = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoUrlString = json["url_h"] as? String,
            let url = URL(string: photoUrlString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
        }
        
        return Photo(title: title, photoId: photoId, remoteUrl: url, dateTaken: dateTaken)
    }
}


