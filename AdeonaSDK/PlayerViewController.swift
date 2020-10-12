//
//  ViewController.swift
//  RtspClient
//
//  Created by Teocci on 18/05/16.
//

import UIKit


class PlayerViewController: UIViewController {

    //@IBOutlet weak var imageView: UIImageView!
  /*  var video: RTSPPlayer!
    var imageView = UIImageView()
    var videoDic = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    func playVideo(_ strURL:String){
        debugPrint("File url is ...\(strURL)")
        video = RTSPPlayer(video: strURL, usesTcp: false)
          video.outputWidth = Int32(UIScreen.main.bounds.width)
          video.outputHeight = Int32(UIScreen.main.bounds.height)
          video.seekTime(0.0)
        imageView.frame = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleAdClick))
        view.addGestureRecognizer(tap)
        self.view.addSubview(imageView)
        let timer = Timer.scheduledTimer(timeInterval: 1.0/30, target: self, selector: #selector(PlayerViewController.update), userInfo: nil, repeats: true)
          timer.fire()
    }
    
    @objc open func handleAdClick(){
        if let actionDic = videoDic["actionData"] as? [String:Any]{
            if let actionURL = actionDic["imageClickUrl"] as? String{
                let url = URL(string: actionURL)!
                    UIApplication.shared.openURL(url)
            }
        }
    }
    
  @objc func update(timer: Timer) {
        if(!video.stepFrame()){
            timer.invalidate()
            video.closeAudio()
        }
        imageView.image = video.currentImage
    
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

