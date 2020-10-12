//
//  popUpAd.swift
//  SOWAdSDK
//
//  Created by PC on 20/08/20.
//  Copyright © 2020 PC. All rights reserved.
//

import UIKit

@objc public protocol popupAdDelegate {
    @objc func receivedPopUpAd(_ adURL: String)
    @objc func didReceivePopUpAdView(_ adView:UIView)
    @objc func didFailToReceivePopUpAd(_ error: AdeonaRequestError?)
}
@objc open class PopUpAd: NSObject {
   
    @objc public static let shared = PopUpAd()
       
    @objc public var delegate:popupAdDelegate?
    
    var category = String()
    var adSpaceId = String()
    var subCategory = String()
     var paramDic = [String:Any]()
    var popUpDic = [String:Any]()
    @objc open var customData = [String:Any]()
     //Show popupAd
    @objc open func show(){
             debugPrint("Show popup Ad!")
          paramDic = Adeona.shared.deviceInfoDic
                paramDic["adSpaceType"] = "popUp"
        paramDic["transactionId"] = "AdSpace1601356784809b2px671129"
        //print("popup:- \(paramDic)")
        if(customData.count > 0){
            paramDic["customData"] = customData
        }
                Adeona.shared.doAdRequest(paramDic) { (result,error)  in
                    
                    
                    if(result.count > 0){
                        debugPrint("AD dic \(result)")
                        if let resourceURL = result["resourceUrl"] as? String{
                            self.downloadImage(resourceURL)
                        }
                        self.popUpDic = result
                        if (self.popUpDic.count > 0){
                            if let refreshInterval = self.popUpDic["refreshFrequency"] as? Int{
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
                        self.delegate?.didFailToReceivePopUpAd(error)
                    }
                }
    }
    
    @objc open func setPopUpAdSpaceId(_ popUpadSpaceId:String){
        self.adSpaceId = popUpadSpaceId
    }
    
    //set category for popup ads
    @objc open func SetCategory(_ strCategory:String){
           self.category = strCategory
           debugPrint(self.category)
       }
       
     //set subcategory for popup ads
       @objc open func SetSubCategory(_ strSubCategory:String){
           self.subCategory = strSubCategory
           debugPrint(self.subCategory)
       }
    
    @objc open func handleAdClick(){
        if (popUpDic.count > 0){
            if let actionDic = popUpDic["actionData"] as? [String:Any]{
                if let actionURL = actionDic["imageClickUrl"] as? String{
                    let url = URL(string: actionURL)!
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    @objc func downloadImage(_ strURL:String) {
         AF.request( strURL,method: .get).response{ response in
            debugPrint("Got response \(response)")
           switch response.result {
            case .success(let responseData):
            debugPrint("Got image")
                //self.myImageView.image = UIImage(data: responseData!, scale:1)
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200))
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleAdClick))
            view.addGestureRecognizer(tap)
            let imageView = UIImageView(frame: view.frame)
            debugPrint("Image frame \(imageView.frame)")
            //imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(data: responseData!, scale:1)
             debugPrint("Image frame \(imageView.image)")
            view.addSubview(imageView)
            
            view.bringSubviewToFront(imageView)
            
            self.delegate?.didReceivePopUpAdView(view)

            case .failure(let error):
                debugPrint("error--->",error)
                //call method when failed to get ad
                self.delegate?.didFailToReceivePopUpAd(AdeonaRequestError(errorCode: error.responseCode ?? 0, errorMessage: error.errorDescription ?? ""))
            }
        }
    }
    
    
   
}
