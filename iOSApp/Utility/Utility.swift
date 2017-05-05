//
//  Utility.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import UIKit
import SVProgressHUD

class Utility: NSObject {
    
    class func showAlert(message: String?) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
        }))
        if let viewController = getHostViewController() {
            viewController.present(alertController, animated:true, completion:nil)
        }
        
    }
    
    class func getHostViewController() -> UIViewController! {
        let appdelegate = UIApplication.shared.delegate
        
        var hostVC = appdelegate!.window!!.rootViewController
        
        while let next = hostVC?.presentedViewController {
            hostVC = next
        }
        
        return hostVC
    }
    
    class func showHud(show: Bool) {
        if show {
            if !SVProgressHUD.isVisible() {
                DispatchQueue.main.async {
                    SVProgressHUD.show()
                }
            }
            
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }
    }
}
