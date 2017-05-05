//
//  FileDownloadManager.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import Foundation

class FileDownloadManager: OperationQueue {
    
//    private let kQueueOperationsChanged = "kQueueOperationsChanged"
//    private let kObserverKeyPath = "FileDownloadManager"
//    private var kvoContext: UInt8 = 1
    private var ccount = 0
    
    public var whenEmpty: (() -> Void)?
    
    
    
    
    override open func addOperation(_ operation: Operation) {
        guard let op = operation as? ImageDownloader else {
            fatalError("This class only works with ImageDownloader objects")
        }
        
        ccount += 1
        
        super.addOperation(operation)
        
        op.privateCompletionBlock = { [weak self] operation in
            guard let sself = self else {
                return
            }
            sself.ccount -= 1
            if sself.ccount == 0 {
                sself.whenEmpty?()
            }
        }
    }
    
    
}
