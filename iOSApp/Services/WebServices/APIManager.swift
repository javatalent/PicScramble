//
//  APIManager.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import UIKit
import ReachabilitySwift

class APIManager: NSObject {
    
    private let reachability = Reachability()
    
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        instance.startReachability()
        return instance
    }()
    
    
    func fetchFlickrFeedMediaItems(block: @escaping (_ success: Bool, _ mediaItems: [MediaItem]?) -> Void) {
        Utility.showHud(show: true)
        if !reachability!.isReachable {
            // show offline message
            Utility.showHud(show: false)
            Utility.showAlert(message: "InternetOffline".localized)
            block(false, nil)
            return
        }
        
        DispatchQueue.global().async {
            let url = NSURL(string: Constants.Urls.kFlickrPublicPhotos)
            
            guard let data =  NSData(contentsOf: url! as URL) else {
                block(false, nil)
                Utility.showHud(show: false)
                Utility.showAlert(message: "InvalidResponse".localized)
                return
            }
            Utility.showHud(show: false)
            do {
                
                if let validData = data.dataByRemovingSpecialCharacters() , let json = try JSONSerialization.jsonObject(with: validData as Data, options: []) as? [String: AnyObject]
                    {
                        DispatchQueue.main.async {
                            block(true, MediaItem.parseJsonFlickrFeed(response: json))
                        }
                        
                }
            } catch {
                block(false, nil)
                Utility.showAlert(message: "InvalidResponse".localized)
                print("Error deserializing JSON: \(error)")
            }
        }
    }
    
    
    
    
    private func startReachability() {
        
        reachability?.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability?.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
}
