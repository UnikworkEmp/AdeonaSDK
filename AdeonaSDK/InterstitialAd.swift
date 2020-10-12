//
//  InterstitialAd.swift
//  AdeonaAdz
//
//  Created by PC on 21/08/20.
//  Copyright © 2020 PC. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

@objc public protocol InterstitialAdDelegate {
    @objc func receivedInterstitialAd(_ adURL: String)
    @objc func didReceiveInterstitialAdView(_ adView: UIViewController)
    @objc func didFailToReceiveInterstitialAd(_ error: AdeonaRequestError?)
}
@objc open class InterstitialAd: NSObject {
    
    @objc public static let shared = InterstitialAd()
       
    @objc open var delegate:InterstitialAdDelegate?
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    var adSpaceId = String()
    var category = String()
    var subCategory = String()
    
    var paramDic = [String:Any]()
    var interstitialDic = [String:Any]()
    @objc open var customData = [String:Any]()
    //Show InterstitialAd
       @objc open func show(){
          debugPrint("Show Video Ad!")
        print("VideoAd:- \(Adeona.shared.deviceInfoDic)")
        //call method when add receive
        /*self.delegate?.receivedInterstitialAd("http://www.google.com") //BannerAd.shared.delegate?.receivedBannerAd("http://www.google.com")
        self.showAd()*/
        paramDic = Adeona.shared.deviceInfoDic
        paramDic["adSpaceType"] = "interstitial"
        paramDic["transactionId"] = "AdSpace1601357381758aoxs757110"
        if(customData.count > 0){
            paramDic["customData"] = customData
        }
        Adeona.shared.doAdRequest(paramDic) { (result,error)  in
            
            
            if(result.count > 0){
                debugPrint("AD dic \(result)")
                if let resourceURL = result["resourceUrl"] as? String{
                    self.downloadImage(resourceURL)
                }
                self.interstitialDic = result
                if (self.interstitialDic.count > 0){
                    if let refreshInterval = self.interstitialDic["refreshFrequency"] as? Int{
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
                self.delegate?.didFailToReceiveInterstitialAd(error)
            }
        }
    }
    
    @objc open func setInterstitialAdSpaceId(_ interstitialAdSpaceId:String){
           self.adSpaceId = interstitialAdSpaceId
       }
    
    //Set category for InterstitialAd
    @objc open func SetCategory(_ strCategory:String){
        self.category = strCategory
        debugPrint(self.category)
    }
    
    //Set subcategory for InterstitialAd
    @objc open func SetSubCategory(_ strSubCategory:String){
        self.subCategory = strSubCategory
        debugPrint(self.subCategory)
    }
    
    func downloadImage(_ strURL:String) {
        
        let url = URL(string: strURL)

        DispatchQueue.global().async {
              if let _ = url{
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleAdClick))
                view.addGestureRecognizer(tap)
                let imageView = UIImageView(frame: view.frame)
                debugPrint("Image frame \(imageView.frame)")
                imageView.image = UIImage(data: data!, scale:1)
                imageView.contentMode = .scaleAspectFit
                 debugPrint("Image frame \(imageView.image)")
                view.addSubview(imageView)
                view.bringSubviewToFront(imageView)
                let vc = VideoViewController()
                vc.view.addSubview(view)
                self.delegate?.didReceiveInterstitialAdView(vc)
                }
              }else{AdeonaRequestError(errorCode: 404, errorMessage: "Ad url not found")
                    self.delegate?.didFailToReceiveInterstitialAd(AdeonaRequestError(errorCode: 404, errorMessage: "Ad url not found"))
                }
        }
        
       /*  AF.request(strURL,method: .get).response{ response in
            debugPrint("Got response \(response)")
           switch response.result {
            case .success(let responseData):
            debugPrint("Got image")
                //self.myImageView.image = UIImage(data: responseData!, scale:1)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleAdClick))
            view.addGestureRecognizer(tap)
            let imageView = UIImageView(frame: view.frame)
            debugPrint("Image frame \(imageView.frame)")
            imageView.image = UIImage(data: responseData!, scale:1)
            imageView.contentMode = .scaleAspectFit
             debugPrint("Image frame \(imageView.image)")
            view.addSubview(imageView)
            view.bringSubviewToFront(imageView)
            let vc = VideoViewController()
            vc.view.addSubview(view)
            self.delegate?.didReceiveInterstitialAdView(vc)

            case .failure(let error):
                debugPrint("error--->",error)
                //call method when failed to get ad
                self.delegate?.didFailToReceiveInterstitialAd(AdeonaRequestError(errorCode: error.responseCode ?? 0, errorMessage: error.errorDescription ?? ""))
            }
        }*/
    }
    
    @objc open func handleAdClick(){
      if (interstitialDic.count > 0){
          if let actionDic = interstitialDic["actionData"] as? [String:Any]{
              if let actionURL = actionDic["imageClickUrl"] as? String{
                  let url = URL(string: actionURL)!
                  UIApplication.shared.openURL(url)
              }
          }
      }
  }
    
}
