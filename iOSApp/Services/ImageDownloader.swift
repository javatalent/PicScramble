//
//  ImageDownloader.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import Foundation

class ImageDownloader: Operation {
    
    var privateCompletionBlock: ((ImageDownloader) -> Void)?
    
    let mediaItem: MediaItem
    var cache: NSCache<AnyObject, NSData>!
    
    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
    }
    
    override func main() {
        
        if self.isCancelled {
            privateCompletionBlock?(self)
            return
        }
        
        guard let mediaUrl = self.mediaItem.mediaUrl, let url = NSURL(string: mediaUrl) else {
            privateCompletionBlock?(self)
            mediaItem.downloadState = .Failed
            return
        }
        
        guard let imageData = NSData(contentsOf: url as URL), imageData.length > 0 else {
            self.mediaItem.downloadState = .Failed
            privateCompletionBlock?(self)
            return
        }
        
        if self.isCancelled {
            privateCompletionBlock?(self)
            return
        }
        
        cache.setObject(imageData, forKey: mediaUrl as AnyObject)
        
        self.mediaItem.downloadState = .Downloaded
        privateCompletionBlock?(self)
    }

}
