//
//  bannerAd.swift
//  AdeonaAdz
//
//  Created by PC on 20/08/20.
//  Copyright © 2020 PC. All rights reserved.
//

import UIKit

@objc public protocol bannerAdDelegate {
    @objc func receivedBannerAd(_ adURL: String)
    @objc func didReceiveBannerAdView(_ bannerView:UIView)
    @objc func didFailToReceiveBannerAd(_ error: AdeonaRequestError?)
}
@objc open class BannerAd: NSObject {
    
    @objc public static let shared = BannerAd()
       
    @objc open var delegate:bannerAdDelegate?
    
    var category = String()
    var adSpaceId = String()
    var subCategory = String()
    
    var paramDic = [String:Any]()
     var bannerDic = [String:Any]()
    @objc open var customData = [String:Any]()
    //Show BannerAd
       @objc open func show(){
          debugPrint("Show Banner Ad!")
        print("BannerAd:- \(Adeona.shared.deviceInfoDic)")
        paramDic = Adeona.shared.deviceInfoDic
        paramDic["adSpaceType"] = "banner"
        paramDic["transactionId"] = "AdSpace1601356712487bat4451936"
        if(customData.count > 0){
           
            paramDic["customData"] = customData
        }
        debugPrint("Final banner Param dict \(paramDic)")
        Adeona.shared.doAdRequest(paramDic) { (result,error)  in
            
           
            if(result.count > 0){
                debugPrint("AD dic \(result)")
                if let resourceURL = result["resourceUrl"] as? String{
                    self.downloadImage(resourceURL)
                }
                self.bannerDic = result
                if (self.bannerDic.count > 0){
                    if let refreshInterval = self.bannerDic["refreshFrequency"] as? Int{
                        debugPrint("refreshInterval \(refreshInterval)")
                         debugPrint("refreshInterval \(Double(refreshInterval))")
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
                self.delegate?.didFailToReceiveBannerAd(error)
            }
        }
    }
    
    @objc open func setBannerAdSpaceId(_ banneradSpaceId:String){
        self.adSpaceId = banneradSpaceId
    }
    
     //set category for banner ads
    @objc open func SetCategory(_ strCategory:String){
        self.category = strCategory
        debugPrint(self.category)
    }
    
    //set subcategory for banner ads
    @objc open func SetSubCategory(_ strSubCategory:String){
        self.subCategory = strSubCategory
        debugPrint(self.subCategory)
    }
    
    @objc open func handleAdClick(){
           if (bannerDic.count > 0){
               if let actionDic = bannerDic["actionData"] as? [String:Any]{
                   if let actionURL = actionDic["imageClickUrl"] as? String{
                       let url = URL(string: actionURL)!
                       UIApplication.shared.openURL(url)
                   }
               }
           }
       }
    
    @objc func downloadImage(_ strURL:String) {
         AF.request(strURL,method: .get).response{ response in
            debugPrint("Got response \(response)")
           switch response.result {
            case .success(let responseData):
            debugPrint("Got image")
                //self.myImageView.image = UIImage(data: responseData!, scale:1)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleAdClick))
            view.addGestureRecognizer(tap)
            let imageView = UIImageView(frame: view.frame)
            debugPrint("Image frame \(imageView.frame)")
            imageView.image = UIImage(data: responseData!, scale:1)
           // imageView.contentMode = .scaleAspectFill
             debugPrint("Image frame \(imageView.image)")
            view.addSubview(imageView)
            view.bringSubviewToFront(imageView)
            
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 20.0) {
                debugPrint("20 interval method called")
                self.show()
            }*/

            self.delegate?.didReceiveBannerAdView(view)

            case .failure(let error):
                debugPrint("error--->",error)
                self.delegate?.didFailToReceiveBannerAd(AdeonaRequestError(errorCode: error.responseCode ?? 0, errorMessage: error.errorDescription ?? ""))
            }
        }
    }
    
    
   
    
    
}

