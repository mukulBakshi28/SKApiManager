//
//  SKApiManager.swift
//  SKHelper
//
//  Created by Sandeep Kumar on 3/31/17.
//  Copyright © 2017 Apptunix. All rights reserved.
//

import UIKit
import Foundation

import Alamofire
import SVProgressHUD

struct ApiHelper
{
    
    static let base_Url            = "http://appzynga.com/projects/marvinlaundry/index.php/api/v1/laundry"
    static let signUp              = "edit"
    static let login               = "loginLaundry"
    static let socialLogin         = "edit_social"
    static let laundryList         = ""
    static let forgot_password     = "forgot_password"
    static let get_addresses       = "get_addresses"
    static let delete_address      = "delete_address"
    static let edit_address        = "edit_address"
    static let select_address      = "get_address"
    static let logout              = "logout"
    static let order               = "order"
    static let get_all_orders      = "get_all_orders"
    static let change_password     = "change_password"
 }




//MARK : - SVProgressHUD
func showLoader()
{
    SVProgressHUD.show()
}

func hideLoader()
{
    SVProgressHUD.dismiss()
}

let serverBaseURL = "http://appzynga.com/projects/marvinlaundry/index.php/api/v1/laundry"

typealias SKApiManagerHandler = ((_ result:Any?, _ Error:Error?) -> Void)!

//MARK : - API
class SKApiManager: NSObject
{
    static let shared = SKApiManager()

}

extension SKApiManager
{
    private func printAPI_Before(strURL:String = "", parameters:[String:Any] = [:], headers:[String:String] = [:])
    {
        var str = "\(parameters)"
        str = str.replacingOccurrences(of: " = ", with: ":")
        str = str.replacingOccurrences(of: "\"", with: "")
        str = str.replacingOccurrences(of: ";", with: "")
        
        print("APi - \(strURL)\nParameters - \(str)\nHeaders - \(headers)")
    }
    
    private func printAPI_After(response:DataResponse<Any>)
    {
//        return
//        print("request: \(response.request)")  // original URL request
//        print("response: \(response.response)")  // URL response
//        print("data: \(response.data)") // server data
        
        
        if let value = response.result.value
        {
            print("result.value: \(value)") // result of response serialization
        }
        if let error = response.result.error
        {
            print("result.error: \(error)") // result of response serialization
        }
    }
    
    private func hitAPI(_ apiURl:String = "",
                      type:HTTPMethod = .get,
                      parameters:[String:Any] = [:],
                      completionHandler: SKApiManagerHandler
        )
    {
        var strURL:String = serverBaseURL
        if apiURl.contains("http")
        {
            strURL = ""
        }
        
        if !strURL.isEmpty && !apiURl.isEmpty
        {
            strURL.append("/")
        }
        strURL.append(apiURl)
        
        var headers:[String:String] = ["Content-Type":"application/x-www-form-urlencoded"]
        if !apiURl.isEmpty
        {
            headers = ["Authorization": ""]
        }
        
        print("strUrl is",strURL)
        
        SKApiManager.shared.printAPI_Before(strURL: strURL, parameters: parameters, headers: headers)

        let api =  Alamofire.request(
            strURL,
            method: type,
            parameters: parameters,
            encoding: URLEncoding.httpBody,
            headers: headers)
        
        api.responseJSON {
            response -> Void in
            
            SKApiManager.shared.printAPI_After(response: response)
            
            if let JSON = response.result.value
            {
                completionHandler(JSON as Any?, nil)
            }
            else if let ERROR = response.result.error
            {
                completionHandler(nil, ERROR as Error?)
            }
            else
            {
                completionHandler(nil, NSError(domain: "error", code: 117, userInfo: nil))
            }
        }
    }
    
    private func uploadAPI(_ apiURl:String = "",
                       uploadObjects:[MultipartObject],
                       parameters:[String:Any] = [:],
                       completionHandler: SKApiManagerHandler
        )
    {
        var strURL:String = serverBaseURL
        if apiURl.contains("http")
        {
            strURL = ""
        }
        
        if !strURL.isEmpty && !apiURl.isEmpty
        {
            strURL.append("/")
        }
        strURL.append(apiURl)

        var headers:[String:String] = [:]//application/x-www-form-urlencoded
//        if !apiURl.isEmpty
//        {
//            headers = ["Authorization": ""]
//        }
     
        //        headers["Content-Type"] = "application/x-www-form-urlencoded"
//        headers["Content-Type"] = "multipart/form-data"
        headers["Content-Type"] = ""
        print("str url is",strURL)
        print("paraDict is",parameters)
        
        
        //Print
        SKApiManager.shared.printAPI_Before(strURL: strURL, parameters: parameters, headers: headers)
        
        let URL2 = try! URLRequest(url: strURL, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: {
            (multipartFormData) in
            
            
            for obj in uploadObjects
            {
                multipartFormData.append(obj.dataObj, withName: obj.strName, fileName: obj.strFileName, mimeType: obj.strMimeType)
            }
            
            for key in parameters.keys
            {
                if let obj = parameters[key]
                {
                    if let arra:NSArray = obj as? NSArray
                    {
                        let stringRepresentation = arra.componentsJoined(by: ",")
                        let strutf8 = stringRepresentation.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        multipartFormData.append(strutf8!, withName: key)
                    }
                    else
                    {
                        if let value = parameters[key]
                        {
                            let str = "\(String(describing: value))"
                            let strutf8 = str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                            multipartFormData.append(strutf8!, withName: key )
                        }
                    }
                }
            }
            
        }, with: URL2) {
            (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON {
                    response in
                    debugPrint(response)
                    
                    //Print
                    SKApiManager.shared.printAPI_After(response: response)
                    
                    if let JSON = response.result.value
                    {
                        print("JSON: \(JSON)")
                        completionHandler(JSON as Any?, nil)
                    }
                    else if let ERROR = response.result.error
                    {
                        print("Error: \(ERROR)")
                        completionHandler(nil, ERROR as Error?)
                    }
                    else
                    {
                        completionHandler(nil, NSError(domain: "error", code: 117, userInfo: nil))
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(nil, NSError(domain: "error", code: 100, userInfo: nil))
            }
        }
    }
//}

//MARk: - Methods
//extension SKApiManager
//{
    class func getAPI(_ apiURl:String = "",
                      parameters:[String:Any] = [:],
                      completionHandler: SKApiManagerHandler
        )
    {
        SKApiManager.shared.hitAPI(
            apiURl,
            type: .get,
            parameters: parameters,
            completionHandler: completionHandler
        )
    }
    
    class func postAPI(_ apiURl:String = "",
                      parameters:[String:Any] = [:],
                      completionHandler: SKApiManagerHandler
        )
    {
        SKApiManager.shared.hitAPI(
            apiURl,
            type: .post,
            parameters: parameters,
            completionHandler: completionHandler
        )
    }
    
    class func postAPI(_ apiURl:String = "",
                       image:UIImage,
                       parameters:[String:Any] = [:],
                       completionHandler: SKApiManagerHandler
        )
    {
        let data:Data = UIImageJPEGRepresentation(image, 0.5)!
        let uploadData = [
            MultipartObject(data: data, name: "profile_pic", fileName: "image.png", mimeType: "image/png")
        ]
          //image,image.png,image/png
        
        SKApiManager.shared.uploadAPI(
            apiURl,
            uploadObjects: uploadData,
            parameters: parameters,
            completionHandler: completionHandler)
        
    }
}

//MARK: - MultipartObject
class MultipartObject: NSObject
{
    //            multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
    var dataObj:Data! = nil
    var strName:String = ""
    var strFileName:String = ""
    var strMimeType:String = ""
    
    init(data:Data!, name:String, fileName:String, mimeType:String)
    {
        super.init()
        dataObj = data
        strName = name
        strFileName = fileName
        strMimeType = mimeType
    }
}
