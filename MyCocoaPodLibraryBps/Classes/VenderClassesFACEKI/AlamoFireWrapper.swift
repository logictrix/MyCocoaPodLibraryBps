
//
//  AlamoFireWrapper.swift
//
//

import UIKit
import Alamofire

class AlamoFireWrapper: NSObject {
    
    let customManager = Alamofire.Session.default
    let timeOutInterval:Double = 60
    
    var progressViewNib = UIView()
    
    class var sharedInstance : AlamoFireWrapper{
        struct Singleton{
            static let instance = AlamoFireWrapper()
        }
        return Singleton.instance;
    }
        
   
    //MARK: MULTIPART API
    func MultipartApiHit(action:String,imageData: Data?,view: UIView,param: [String:Any], withName: String, fileName: String, mimeType: String, onSuccess: @escaping(AFDataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){

        let url : String = baseUrl + action
        print("url",url)
        print("param ",param)
        print("withName: \(withName) \nfileName: \(fileName) \nmimeType: \(mimeType)")

        let headers: HTTPHeaders = [
            "Content-type": "application/json",
            "Authorization": "Bearer \(DataManager.authorizationTokken ?? "NA")"
        ]
        print("headers ",headers)
       
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in param {
                   if let temp = value as? String {
                       multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                   }
                   if let temp = value as? Int {
                       multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                   }
                   if let temp = value as? NSArray {
                       temp.forEach({ element in
                       let keyObj = key + "[]"
                       if let string = element as? String {
                           multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                       } else
                           if let num = element as? Int {
                           let value = "\(num)"
                           multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                           }
                       })
                   }
                }
                multipartFormData.append(imageData!, withName: "image" , fileName: "file.jpg", mimeType: "image/jpg")
                //, fileName: "file.jpeg", mimeType: "image/jpeg"
//               progressBar.progress = Float(50.0)
        },
            to: url, method: .post , headers: headers)
            .responseJSON {
                (response:AFDataResponse<Any>) in
                print("response ",response)
                switch(response.result) {
                case .success( _):
                    onSuccess(response)
                    break
                case .failure(let error):
                    print("error==> ",error)
                    onFailure(error)
                    break
                }
        }
    }
    
    
    //MARK:- Post Request
    func PostApiHit(action:String,param: [String:Any],view: UIView, onSuccess: @escaping(AFDataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseUrl + action
        print("url ",url)
//        print("param ",param)
        
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:AFDataResponse<Any>) in
            print("response ",response)
            
//            AF.request(APIRouter.testGet).responseDecodable(decoder: jsonDecoder) { (response: DataResponse<[ObjectA], AFError>) in
//                    if let data = response.data {
//                        print(String(data: data, encoding: .utf8)!)
//                    }
//            }
            
            switch(response.result) {
            case .success(_):
                onSuccess(response)
                break
            case .failure(let error):
                print("error==> ",error)
                DispatchQueue.main.async {
                    CommonFunctions.dismissProgressView(view: view)
                }
                break
            }
        }
    }
    
    //MARK: MULTIPART API
    func verificationDocMultipartApiHit(action:String,imagesData: [Data?],fetchImageParamNameArray: [String],view: UIView,param: [String:Any], withName: String, fileName: String, mimeType: String, onSuccess: @escaping(AFDataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){

        let url : String = baseUrl + action
        print("url",url)
        print("param ",param)
        print("withName: \(withName) \nfileName: \(fileName) \nmimeType: \(mimeType)")
       
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(DataManager.authorizationTokken ?? "NA")"
        ]
        print("headers ",headers)
        
        var imageParamNameArray = fetchImageParamNameArray
        
        AF.upload(
            multipartFormData: { multipartFormData in
                
                for imageData in imagesData {
                    let imageParamName = imageParamNameArray[0]
                    imageParamNameArray.remove(at: 0)
                    multipartFormData.append(imageData!, withName: "\(imageParamName)", fileName: "\(imageParamName).jpg", mimeType: "\(imageParamName)/jpg")
                }
                //Date().timeIntervalSince1970
               
                for (key, value) in param {
                    
                   if let temp = value as? String {
                       multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                   }
                    
                   if let temp = value as? Int {
                       multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                   }
                    
                   if let temp = value as? NSArray {
                       temp.forEach({ element in
                       let keyObj = key + "[]"
                       if let string = element as? String {
                           multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                       } else
                           if let num = element as? Int {
                           let value = "\(num)"
                           multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                           }
                       })
                   }
                                         
           }
                
        },
            to: url, method: .post , headers: headers)
            .responseJSON {
                (response:AFDataResponse<Any>) in
                print("response ",response)
                switch(response.result) {
                case .success( _):
                    onSuccess(response)
                    break
                case .failure(let error):
                    print("error==> ",error)
                    onFailure(error)
                    break
                }
        }
    }
    
    
     //MARK:- Normal Get Request
    func GetApiHit(action:String,view: UIView, onSuccess: @escaping(AFDataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        print("action url", action)
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(DataManager.authorizationTokken ?? "NA")"
        ]
        print("headers ",headers)
        
        let strURL : String = baseUrl2+action
        print("strURL ",strURL)
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print("urlwithPercentEscapes", urlwithPercentEscapes as Any)
        
        AF.request(urlwithPercentEscapes!, method: .get, headers: nil).responseJSON {
            (response:AFDataResponse<Any>) in
            print("API Url", baseUrl+action)
            //                print("response GetApiHit", response)
            switch(response.result) {
            case .success(_):
                onSuccess(response)
                break
            case .failure(let error):
                print("error==> ",error)
                DispatchQueue.main.async {
                    CommonFunctions.dismissProgressView(view: view)
                    onFailure(error)
                }
                break
            }
        }
    }
    
   
    
   
}


