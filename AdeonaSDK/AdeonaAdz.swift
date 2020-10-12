//
//  AdeonaAdz.swift
//  AdeonaAdz
//
//  Created by PC on 20/08/20.
//  Copyright © 2020 PC. All rights reserved.
//

import UIKit
import Alamofire

@objc public class AdeonaRequestError:NSObject {
    public var errorCode: Int?
    @objc public var errorMessage: String?
    init(errorCode: Int,errorMessage:String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
   }
}

@objc public protocol AdeonaAdzProtocol {
}

@objc open class Adeona: NSObject {
    
    @objc public static let shared = Adeona()
    
    @objc public var delegate:AdeonaAdzProtocol?
     
    var appId = String()
    var requestURL = "https://iap.gateway.adareach.com/api/adRequest"//"http://smartmessenger.lk:7000/api/adRequest"

    private let session: Session = {
        let manager = ServerTrustManager(evaluators: ["iap.gateway.adareach.com": DisabledEvaluator()])
        let configuration = URLSessionConfiguration.af.default

        return Session(configuration: configuration, serverTrustManager: manager)
    }()
    
    var deviceInfoDic = [String:Any]()
    
    //Set app id for app Unique identifier for mobile app
    @objc open func setAppId(_ appId:String){
        self.appId = appId
        print("App id \(self.appId)")
    }
    
    @objc open func getAppId() -> String{
        return self.appId
    }
    
    
    
    @objc open func setDeviceInformation( _ deviceDic:[String:Any]) {
        //Default parameter adding
        var finalDic = deviceDic
        finalDic.updateValue(getScreenWidth(), forKey: "screenWidth")
        finalDic.updateValue("iOS", forKey: "os")
        finalDic.updateValue("Apple", forKey: "deviceBrand")
        finalDic.updateValue(getDeviceModel(), forKey: "deviceModel")
        finalDic.updateValue(getDeviceId(), forKey: "deviceId")
        finalDic.updateValue(getCurrentOSVersion(), forKey: "osVersion")
        finalDic.updateValue(getAppVersion(), forKey: "appVersion")
        finalDic.updateValue(getScreenHeight(), forKey: "screenHeight")
       // finalDic.updateValue(UUID().uuidString, forKey: "transactionId")
        finalDic.updateValue("ABC technologies", forKey: "vendor")
        self.deviceInfoDic = finalDic
        print("Device info \(self.deviceInfoDic)")
    }
    
    private func getScreenWidth() -> String{
        let screenWidth = UIScreen.main.bounds.width
        return "\(screenWidth)"
    }
    
    private func getDeviceModel() -> String{
        return UIDevice.modelName
    }
    
    private func getDeviceId() -> String{
        let uuid = UIDevice.current.identifierForVendor
        return "\(uuid!)"
    }
    
    private func getCurrentOSVersion() -> String{
        let systemVersion = UIDevice.current.systemVersion
        return "\(systemVersion)"
    }
    
    private func getAppVersion() -> String{
        return Bundle.main.fullVersion
    }
    
    private func getScreenHeight() -> String{
        let screenHeight = UIScreen.main.bounds.height
        return "\(screenHeight)"
    }
    
    
    
    
    //Api call request for banner ad
       func doAdRequest( _ paramDic:[String:Any],completion: @escaping (_ result: [String:Any],_ error:AdeonaRequestError?) -> Void) {
//        let manager = ServerTrustManager(evaluators: ["iap.gateway.adareach.com": PinnedCertificatesTrustEvaluator()])
//        let session = Session(serverTrustManager: manager)
        
         session.request(requestURL, method: .post,  parameters: paramDic, encoding: JSONEncoding.default)
             .responseJSON { response in
                 switch response.result {
                   
                 case .success(let value):
                     if let json = value as? [String: Any] {
                       debugPrint(json)
                       //  debugPrint(json["resourceUrl"] as? Int)
                       completion(json,nil)
                     }
                 case .failure(let error):
                     debugPrint(error)
                     completion([:],AdeonaRequestError(errorCode: error.responseCode ?? 0, errorMessage: error.errorDescription ?? ""))
                     
                 }
           }
       }
}
