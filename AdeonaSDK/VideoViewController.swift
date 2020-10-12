//
//  VideoViewController.swift
//  AdeonaAdz
//
//  Created by PC on 24/08/20.
//  Copyright © 2020 PC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
//have to change this class name
class VideoViewController: UIViewController {

   /// var player: AVPlayer!
    //var avpController = AVPlayerViewController()
   // var videoView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.showVideoAd("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        debugPrint("Viewdidload done")
    }
    
    func showVideoAd(_ strURL:String){
        /*let url = URL(string:strURL)
        player = AVPlayer(url: url!)
        avpController.player = player
        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)


        videoView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
           
        avpController.view.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                  
        debugPrint("Avplayer frame \(avpController.view.frame)")
        videoView.addSubview(avpController.view)
        debugPrint("view frame \(videoView.frame)")
        videoView.bringSubviewToFront(avpController.view)*/
       }
    
   /* override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       if object as AnyObject? === player {
           if keyPath == "status" {
               if player.status == .readyToPlay {
                   player.play()
               }
            }
           }
       }*/

}
