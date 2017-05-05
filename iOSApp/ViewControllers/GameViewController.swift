//
//  ViewController.swift
//  iOSApp
//
//  Created by kushal  on 04/05/17.
//  Copyright © 2017 kushal. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    var counter = 15
    var userTapCount = 0
    var randomNumbers = [0,1,2,3,4,5,6,7,8]
    
    var timer: Timer!
    var randomIndex : Int!
    
    var cache: NSCache<AnyObject, NSData>!
    fileprivate var mediaItems: [MediaItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initCache()
        self.fetchFlickrFeedMediaItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func initCache() {
        self.cache = NSCache()
        self.cache.countLimit = 100
        self.cache.totalCostLimit  = 30
    }
    
    
    @IBAction func startNewGameButtonAction(_ sender: Any) {
        reset()
        self.fetchFlickrFeedMediaItems()
    }
    

}

extension GameViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCollectionViewCell
        
        let mediaItem = self.mediaItems[indexPath.item]
        cell.configureCell(mediaItem: mediaItem, cache: self.cache)
        if mediaItem.flip {
            cell.flipView(mediaItem: mediaItem)
        }
        return cell
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaItem = self.mediaItems[indexPath.item]
        if mediaItem.previewState != .Highlighted {
            return
        }
        userTapCount += 1
        self.messageLabel.text = "Attempt: \(userTapCount)"
        let selectedMediaItem = self.mediaItems[randomIndex]
        if mediaItem == selectedMediaItem {
            mediaItem.flip = true
            mediaItem.previewState = .Answered
            let cell = collectionView.cellForItem(at: indexPath) as! GameCollectionViewCell
            cell.configureCell(mediaItem: mediaItem, cache: self.cache)
            cell.flipView(mediaItem: mediaItem)
            
            if randomNumbers.isEmpty {
                self.messageLabel.text = "You won. Total attempt is \(userTapCount)"
                self.previewImageView.isHidden = true
            } else {
                generateRandomPreviewImage()
            }
            
        }
        
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/3-2), height: (collectionView.frame.size.height/3-2))
    }
    
}

extension GameViewController {
    func startGame() {
        self.messageLabel.text = "15"
        collectionView.reloadData()
        
        self.previewImageView.isHidden = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.timerUpdated), userInfo: nil, repeats: true)
        
    }
    
    func reset() {
        self.messageLabel.text = "Please wait..."
        randomNumbers = [0,1,2,3,4,5,6,7,8]
        counter = 15
        self.previewImageView.isHidden = true
        userTapCount = 0
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        for mediaItem in mediaItems {
            mediaItem.mediaUrl = nil
            mediaItem.flip = false
            mediaItem.previewState = .Normal
        }
        self.collectionView.reloadData()
        
    }
    
    func timerUpdated() {
        counter -= 1
        if counter > 0 {
            self.messageLabel.text = String(counter)
        } else {
            self.timer.invalidate()
            self.timer = nil
            self.messageLabel.text = "Attempt: 0"
            self.previewImageView.isHidden = false
            flipTiles()
            generateRandomPreviewImage()
        }
    }
    
    func flipTiles() {
        for mediaItem in mediaItems {
            mediaItem.flip = true
            mediaItem.previewState = .Highlighted
        }
        self.collectionView.reloadData()
    }
    
    func generateRandomPreviewImage() {
        let arrayKey = Int(arc4random_uniform(UInt32(randomNumbers.count)))
        
        // your random number
        randomIndex = randomNumbers[arrayKey]
        
        // make sure the number isnt repeated
        randomNumbers.remove(at: arrayKey)
        let mediaItem = mediaItems[randomIndex]
        if let mediaUrlStr = mediaItem.mediaUrl, let data = cache.object(forKey: mediaUrlStr as AnyObject) {
            previewImageView.image = UIImage(data: data as Data)
        }
        
        
    }

}

extension GameViewController {
    func fetchFlickrFeedMediaItems() {
        APIManager.sharedInstance.fetchFlickrFeedMediaItems() { (success, mediaItems) in
            if success {
                if mediaItems != nil {
                    self.mediaItems = mediaItems!
                    self.downloadMedia()
                }
            }
        }
    }
    
    func downloadMedia() {
        Utility.showHud(show: true)
        
        let downloadManager = FileDownloadManager()
        downloadManager.whenEmpty =  {
            DispatchQueue.main.async {
                Utility.showHud(show: false)
                self.startGame()
            }
            
        }
        for mediaItem in self.mediaItems {
            let imageDownloader = ImageDownloader(mediaItem: mediaItem)
            imageDownloader.cache = self.cache
            downloadManager.addOperation(imageDownloader)
        }
    
    }
    
    func imagesDownloaded() {
        
    }
}

