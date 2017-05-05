//
//  GameCollectionViewCell.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCell(mediaItem: MediaItem, cache: NSCache<AnyObject, NSData>) {
        if mediaItem.previewState == .Highlighted {
            imageView.image = UIImage(named: "high")
            return
        }
        if let mediaUrlStr = mediaItem.mediaUrl, let data = cache.object(forKey: mediaUrlStr as AnyObject) {
            imageView.image = UIImage(data: data as Data)
        } else {
            imageView.image = nil
        }
    
    }
    
    func flipView(mediaItem: MediaItem) {
        let option  = mediaItem.previewState == .Highlighted ? UIViewAnimationOptions.transitionFlipFromLeft : UIViewAnimationOptions.transitionFlipFromRight
        
        UIView.transition(with: imageView, duration: 1.0, options: option, animations: { () -> Void in
            
        }) { (success) -> Void in
//            self.configureCell(mediaItem: mediaItem, cache: cache)
        }
        
        
    }
    
}
