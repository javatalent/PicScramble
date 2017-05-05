//
//  Constants.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Urls {
        static let kFlickrPublicPhotos = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    }
    
    struct Notifications {
        static let kImageDownloadCompleted = "ImageDownloadCompletedNotification"
    }
    
    struct JsonKeys {
        static let kItems: String = "items"
        static let kTitle = "title"
        static let kMedia = "media"
        static let kM = "m"
    }
    
}
