//
//  NativeAd.swift
//  AdeonaAdz
//
//  Created by PC on 21/08/20.
//  Copyright © 2020 PC. All rights reserved.
//

import UIKit

@objc public protocol nativeAdDelegate {
    @objc func receivedNativeAd(_ adURL: String)
    @objc func didReceiveNativeAdView(_ nativeView:UIView)
    @objc func didFailToReceiveNativeAd(_ error: AdeonaRequestError?)
}
@objc open class NativeAd: NSObject {
    
    public static let shared = NativeAd()
       
    @objc public var delegate:nativeAdDelegate?
    
    var category = String()
    var adSpaceId = String()
    var subCategory = String()
    var paramDic = [String:Any]()
    var nativeDic = [String:Any]()
    @objc open var customData = [String:Any]()
    //Show NativeAd
    @objc open func show(){
          debugPrint("Show Native Ad!")
        print("NativeAd:- \(Adeona.shared.deviceInfoDic)")
        //call method when add receive
        //self.delegate?.receivedNativeAd("http://www.google.com") //BannerAd.shared.delegate?.receivedBannerAd("http://www.google.com")
       // self.loadNativeAd()
        
        paramDic = Adeona.shared.deviceInfoDic
        paramDic["adSpaceType"] = "native"
        paramDic["transactionId"] = "AdSpace1601356912279hq7k420084"
        if(customData.count > 0){
            paramDic["customData"] = customData
        }
        Adeona.shared.doAdRequest(paramDic) { (result,error)  in
            
            
            if(result.count > 0){
                debugPrint("AD dic \(result)")
                if let resourceURL = result["resourceUrl"] as? String{
                    self.downloadImage(resourceURL)
                }
                self.nativeDic = result
                if (self.nativeDic.count > 0){
                    if let refreshInterval = self.nativeDic["refreshFrequency"] as? Int{
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
                self.delegate?.didFailToReceiveNativeAd(error)
            }
        }
    }
    
    @objc open func setNativeAdSpaceId(_ nativeAdSpaceId:String){
        self.adSpaceId = nativeAdSpaceId
    }
    
    //Set category for nativeAd
    @objc open func SetCategory(_ strCategory:String){
        self.category = strCategory
        debugPrint(self.category)
    }
    
    //Set subcategory for nativeAd
    @objc open func SetSubCategory(_ strSubCategory:String){
        self.subCategory = strSubCategory
        debugPrint(self.subCategory)
    }
    
    @objc open func handleAdClick(){
             if (nativeDic.count > 0){
                 if let actionDic = nativeDic["actionData"] as? [String:Any]{
                     if let actionURL = actionDic["imageClickUrl"] as? String{
                         let url = URL(string: actionURL)!
                         UIApplication.shared.openURL(url)
                     }
                 }
             }
         }
      
      @objc func downloadImage(_ strURL:String) {
        
        let url = URL(string: strURL)

        DispatchQueue.global().async {
             if let _ = url{
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                 let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleAdClick))
                 view.addGestureRecognizer(tap)
                 let imageView = UIImageView(frame: view.frame)
                 debugPrint("Image frame \(imageView.frame)")
                 imageView.image = UIImage(data: data!, scale:1)
                 imageView.contentMode = .scaleAspectFill
                  debugPrint("Image frame \(imageView.image)")
                 view.addSubview(imageView)
                 view.bringSubviewToFront(imageView)
                 
                 self.delegate?.didReceiveNativeAdView(view)
                }
             }else{
                    self.delegate?.didFailToReceiveNativeAd(AdeonaRequestError(errorCode: 404, errorMessage: "Ad url not found"))
                }
        }
        
         /*  AF.request(strURL,method: .get).response{ response in
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
              imageView.contentMode = .scaleAspectFill
               debugPrint("Image frame \(imageView.image)")
              view.addSubview(imageView)
              view.bringSubviewToFront(imageView)
              
              self.delegate?.didReceiveNativeAdView(view)

              case .failure(let error):
                  debugPrint("error--->",error)
                  self.delegate?.didFailToReceiveNativeAd(AdeonaRequestError(errorCode: error.responseCode ?? 0, errorMessage: error.errorDescription ?? ""))
              }
          }*/
      }
}


