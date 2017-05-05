//
//  MediaItem.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import UIKit

enum DownloadState {
    case New, Downloaded, InProgress, Failed
}

enum PreviewState {
    case Normal, Highlighted, Answered
}

class MediaItem: NSObject {
    
    var title: String?
    var mediaUrl: String?
    var downloadState = DownloadState.New
    var flip = false
    var previewState = PreviewState.Normal
    
    
    public init (item: [String : AnyObject]) {
        
        self.title = item[Constants.JsonKeys.kTitle] as? String
        guard let media = item[Constants.JsonKeys.kMedia] as? [String : String] else {
            return
        }
        self.mediaUrl = media[Constants.JsonKeys.kM]
    }

}
