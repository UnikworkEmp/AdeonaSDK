//
//  VideoAd.swift
//  AdeonaAdz
//
//  Created by PC on 21/08/20.
//  Copyright © 2020 PC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire

@objc public protocol videoAdDelegate {
    @objc func receivedVideoAd(_ adURL: String)
    @objc func didReceiveVideoAdView(_ videoView:UIViewController)
    @objc func didFailToReceiveVideoAd(_ error: AdeonaRequestError?)
    
}
@objc open class VideoAd: NSObject {
    
    @objc public static let shared = VideoAd()
       
    @objc open var delegate:videoAdDelegate?
  
    var player :AVPlayer?
    var playerItem: AVPlayerItem?
    var avPlayerLayer: AVPlayerLayer?
    
    var videoView = UIView()
    
    var adSpaceId = String()
    var category = String()
    var subCategory = String()
    
    var paramDic = [String:Any]()
    var videoDic = [String:Any]()
    var isFirstTime = Bool()
    let vc = PlayerViewController()

    @objc open var customData = [String:Any]()
    
    //Show VideoAd
    @objc open func show(){
          debugPrint("Show Video Ad!")
        print("VideoAd:- \(Adeona.shared.deviceInfoDic)")
        //call method when add receive
    
        paramDic = Adeona.shared.deviceInfoDic
               paramDic["adSpaceType"] = "video"
        paramDic["transactionId"] = "AdSpace1601357308822kve4454504"
        if(customData.count > 0){
            paramDic["customData"] = customData
        }
        debugPrint("Video Param dic \(paramDic)")
               Adeona.shared.doAdRequest(paramDic) { (result,error)  in
                   if(result.count > 0){
                       debugPrint("AD dic \(result)")
                       self.videoDic = result
                    if (self.videoDic.count > 0){
                        if let refreshInterval = self.videoDic["refreshFrequency"] as? Int{
                            if(refreshInterval > 0){
                                DispatchQueue.main.asyncAfter(deadline: .now() + Double(refreshInterval)) {
                                    debugPrint("\(refreshInterval) interval method called")
                                    self.show()
                                }
                            }
                        }
                    }
                   }else{
                       //call method when failed to get ad
                       self.delegate?.didFailToReceiveVideoAd(error)
                   }
                   if let resourceURL = result["resourceUrl"] as? String{
                    self.startplayer("https://d1go4s7xoxr47m.cloudfront.net/Peugeot.mp4")//(resourceURL)
//                    let vc = PlayerViewController()
//                    vc.videoDic = self.videoDic
//                    vc.playVideo(resourceURL)
//                    self.delegate?.didReceiveVideoAdView(vc)
                   }
                   
               }
    }
    
    @objc open func setVideoAdSpaceId(_ videoAdSpaceId:String){
        self.adSpaceId = videoAdSpaceId
    }
    
    //Set category for VideoAd
    @objc open func SetCategory(_ strCategory:String){
        self.category = strCategory
        debugPrint(self.category)
    }
    
    //Set subcategory for VideoAd
    @objc open func SetSubCategory(_ strSubCategory:String){
        self.subCategory = strSubCategory
        debugPrint(self.subCategory)
    }
    
    /*func showVideoAd(_ strURL:String){
        let url = URL(string:strURL)
        player = AVPlayer(url: url!)
        avpController.player = player
        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        videoView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
        
        avpController.view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 250)
               
        debugPrint("Avplayer frame \(avpController.view.frame)")
               videoView.addSubview(avpController.view)
        debugPrint("view frame \(videoView.frame)")
        videoView.bringSubviewToFront(avpController.view)
        
        
    }*/
    
    
    func startplayer(_ strURL:String){

    playerItem =  AVPlayerItem.init(url: URL.init(string: strURL)!)
    player = AVPlayer.init(playerItem: playerItem)
    player?.allowsExternalPlayback = true
    avPlayerLayer = AVPlayerLayer.init(player: player)
    videoView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    avPlayerLayer?.videoGravity = .resizeAspect
    videoView.layer.insertSublayer(avPlayerLayer!, at: 0)

        player?.currentItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let currentPlayer = player , let playerObject = object as? AVPlayerItem, playerObject == currentPlayer.currentItem, keyPath == "status"
        {
            if ( currentPlayer.currentItem!.status == .readyToPlay)
            {
                currentPlayer.play()
                currentPlayer.rate = 1.0;
                player!.play()
                vc.view.addSubview(self.videoView)
                self.delegate?.didReceiveVideoAdView(vc)
                //self.delegate?.didReceiveVideoAdView(self.videoView, player: player!)
            }
        }
    }
    
   /* override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if object as AnyObject? === player {
        if keyPath == "status" {
            if player.status == .readyToPlay {
                player.play()
                self.delegate?.didReceiveVideoAdView(self.videoView, player: player)
            }
        }
        }
    }*/
    
}

