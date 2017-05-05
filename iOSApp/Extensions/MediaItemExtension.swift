//
//  MediaItemExtension.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import Foundation

extension MediaItem
{
    class func parseJsonFlickrFeed(response: [String : AnyObject]?)-> [MediaItem]
    {
        var mediaItems = [MediaItem]()
        guard let result = response, let items = result[Constants.JsonKeys.kItems] as? [[String : AnyObject]], !items.isEmpty else {
            return []
        }
        var count = 0
        for item in items {
            let mediaItem = MediaItem(item: item)
            mediaItems.append(mediaItem)
            count += 1
            if count == 9 {
                break
            }
        }
        
        return mediaItems
    }
}
