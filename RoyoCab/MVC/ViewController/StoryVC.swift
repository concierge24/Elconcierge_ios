//
//  StoryVC.swift
//  RoyoRide
//
//  Created by Prashant on 07/07/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import AVFoundation

class StoryVC: UIViewController {
    
    @IBOutlet weak var imgViewBG: UIImageView!
    @IBOutlet weak var clcView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var pageIndicator: CHIPageControlJaloro!
    
    var storyArray = [StoryModel]()
    var collectionViewDataSource : CollectionViewDataSourceCab?
    var player:AVPlayer?
    var durationInSeconds = 0
    var currentTimeInSeconds = 0
    var previousIndex = -1
    
    var timeObserver:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  https://homepages.cae.wisc.edu/~ece533/images/watch.png
        // Do any additional setup after loading the view.
        storyArray = [StoryModel(url:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",isVideo:true),
                      StoryModel(url:"https://homepages.cae.wisc.edu/~ece533/images/watch.png",isVideo:false),
                      StoryModel(url:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",isVideo:true),
                      StoryModel(url:"https://homepages.cae.wisc.edu/~ece533/images/monarch.png",isVideo:false),
                      StoryModel(url:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",isVideo:true)]
        setupPageController()
        configureCollectionView()
    }
    
    
    func setupPageController(){
        
        pageIndicator.numberOfPages = storyArray.count
        pageIndicator.radius = 3.0
        pageIndicator.set(progress: 0, animated: true)
        pageIndicator.currentPageTintColor = UIColor.red
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let player = player{
            
            player.pause()
            if let timeObserver = timeObserver{
                
                player.removeTimeObserver(timeObserver)
            }
            self.player = nil
        }
        
    }
    
    
    func setupPlayer(url:String?){
        
        if let player = player{
            
            if let timeObserver = timeObserver{
                
                player.removeTimeObserver(timeObserver)
            }
            self.player = nil
        }
        
        if let url = URL(string:url ?? "") {
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            timeObserver =  player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
                if let duration = self?.player?.currentItem?.duration {
                    
                    let durationSeconds = CMTimeGetSeconds(duration)
                    let seconds = CMTimeGetSeconds(progressTime)
                    let progress = Float(seconds/durationSeconds)
                  //  self?.durationInSeconds = Int(durationSeconds)
                   // self?.currentTimeInSeconds = Int(seconds)
                    
                    DispatchQueue.main.async {
                        //  self?.progressBar.progress = progress
                        if progress >= 1.0 {
                            //  self?.progressBar.progress = 0.0
                        }
                    }
                }
            }
        }
    }
    
    func playVideo(){
        
        player?.play()
    }
    
    func pauseVideo(){
        
        player?.pause()
    }
    
    func muteVideo(){
        
        player?.isMuted = !(/player?.isMuted)
    }
    
    @IBAction func btnCrossAction(_ sender: Any) {
        
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.popVC()
    }
    
    
    
    private func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {
            [weak self] (cell, item, indexPath) in
            
            if let cell = cell as? StoryClcCell, let model = item as? StoryModel {
                
                cell.imgView.isHidden = /model.isVideo
                cell.viewPlayerContainer.isHidden = !(/model.isVideo)
                
                if self?.previousIndex == -1 && /model.isVideo{
                    
                    self?.setupPlayer(url: self?.storyArray[indexPath.row].urlStr)
                    cell.setupPlayer(player: self?.player)
                    self?.previousIndex = indexPath.row
                    
                }
               
              
              
            }
            
        }
        
        let didSelectBlock : DidSelectedRowCab = { [weak self] (indexPath, cell, item) in
            
            
            if self?.player?.timeControlStatus == AVPlayer.TimeControlStatus.playing{
                self?.pauseVideo()
            } else{
                
                self?.playVideo()
            }
        }
        
        
        
        
        let height = self.view.frame.height
        let width = self.view.frame.width
        
        
        collectionViewDataSource = CollectionViewDataSourceCab(items:  storyArray , collectionView: clcView, cellIdentifier:R.reuseIdentifier.storyClcCell.identifier, cellHeight:height, cellWidth: width , configureCellBlock: configureCellBlock, aRowSelectedListener: didSelectBlock)
        
        
        collectionViewDataSource?.centreCellListener = {[weak self](indexPath) in
            
          
            self?.pageIndicator.set(progress: indexPath.row, animated: true)
            let storyModel = self?.storyArray[indexPath.row]
            
            if /storyModel?.isVideo{
                
                if self?.previousIndex == indexPath.row {
                    
                    self?.playVideo()
                    return
                    
                }
                if let cell = self?.clcView.cellForItem(at: indexPath) as? StoryClcCell{
                    cell.imgView.image = nil
                    self?.setupPlayer(url: storyModel?.urlStr)
                    cell.setupPlayer(player: self?.player)
                    
                    cell.imgView.isHidden = /storyModel?.isVideo
                    cell.viewPlayerContainer.isHidden = !(/storyModel?.isVideo)
                    
                }
                
            }
            else{
                
                if let cell = self?.clcView.cellForItem(at: indexPath) as? StoryClcCell{
                    cell.imgView.isHidden = /storyModel?.isVideo
                    cell.viewPlayerContainer.isHidden = !(/storyModel?.isVideo)
                    guard let url = URL(string:storyModel?.urlStr ?? "") else{return}
                    cell.imgView.kf.setImage(with:url)
                    
                }
                
            }
             self?.previousIndex = indexPath.row
            
            
        }
        
        collectionViewDataSource?.scrollViewListener = {[weak self](_) in
            
            
            self?.pauseVideo()
        }
        
        
        
        clcView.delegate = collectionViewDataSource
        clcView.dataSource = collectionViewDataSource
        clcView.reloadData()
    }
    
}

