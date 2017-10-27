//
//  RequestManager.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable force_unwrapping

import Foundation
import RxSwift
import ObjectMapper
import Alamofire

public enum NeedToken {
    case `true`
    case `false`
    case `default`
}

public struct AppError: Error {
    var message: String = ""
    var status: StatusType = .none
}

class RequestManager {
    static func reqeust<T: Mappable>(_ router: Router,
                                     needToken: NeedToken = .true) -> Observable<T> {
     return   Observable<T>.create { (observer) -> Disposable in
        var urlRequest = router.urlRequest
        var header = Header().toJSON()
        if case .false = needToken {
            header.removeValue(forKey: "token")
        }
        if case .default = needToken {
            header.removeValue(forKey: "token")
        }
        header.forEach { (key, value) in
            if let string = value as? String {
                urlRequest?.setValue(string, forHTTPHeaderField: key)
            }
        }
        let requst = Alamofire.request(urlRequest!)
        let body = try? JSONSerialization.jsonObject(with: (requst.request?.httpBody) ?? Data(), options: JSONSerialization.ReadingOptions.allowFragments)
        print("******Header*******\(requst.request?.allHTTPHeaderFields ?? [:])")
        print("******RequestURL*******\(urlRequest!.url?.absoluteString ?? "")")
        print("******Method*******\(urlRequest!.httpMethod ?? "")")
        print("******Body*******\(body ?? [: ])")
        var appError = AppError()
        requst.responseString(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                guard let responseObj = Mapper<BaseResponseObject<T>>().map(JSONString: value) else {
                    observer.on(.completed)
                    return
                }
                if responseObj.status == .success {
                    if let obj = Mapper<T>().map(JSONString: value) {
                        observer.on(.next(obj))
                        observer.onCompleted()
                    } else {
                        appError.message = "Data Parase Error"
                        observer.on(.error(appError))
                        HUD.showError(appError.message)
                    }
                } else {
                    appError.status = responseObj.status
                    if responseObj.status == .loginInValid {  /// 通知重新登录
                        appError.message = "Data Parase Error"
                        observer.on(.error(appError))
                    } else {
                        appError.message = responseObj.description ?? "Error"
                        observer.on(.error(appError))
                    }
                }
            case .failure(let error):
                appError.message = error.localizedDescription
                observer.on(.error(appError))
                break
            }
        })
            return Disposables.create()
        }
    }

    static func upload<T: Mappable>(_ router: URLRequestConvertible, param: Mappable, fileData: [Data]) -> Observable<T> {
         return   Observable<T>.create { (observer) -> Disposable in
            Alamofire.upload(multipartFormData: { multipartFormData in
                fileData.forEach { (data) in
                    multipartFormData.append(data, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                print(multipartFormData)
                if let dic = param.toJSON() as? [String: String] {
                    for (key, value) in dic {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, with: router) { result in
               var appError = AppError()
                switch result {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.validate().responseJSON(completionHandler: { (response) in
                        debugPrint("****************uploadImageResult:\(response.result)***********")
                        switch response.result {
                        case .success(let value):
                            guard let responseJson = value as? [String: Any] else {
                                observer.on(.completed)
                                return
                            }
                            guard let responseObj = Mapper<BaseResponseObject<T>>().map(JSON: responseJson) else {
                                observer.on(.completed)
                                return
                            }
                            if responseObj.status == .success {
                                if let obj = Mapper<T>().map(JSON: responseJson) {
                                    observer.on(.next(obj))
                                } else {
                                    appError.message = "Data Parase Error"
                                    observer.on(.error(appError))
                                }
                            }
                            if responseObj.status == .loginInValid {  /// 通知重新登录
                                appError.message = "Data Parase Error"
                                observer.on(.error(appError))
                            }
                        case .failure(let error):
                            appError.message = error.localizedDescription
                            observer.on(.error(appError))
                        }
                    })
                case .failure(let error):
                    debugPrint("****************uploadImageResult:\(error.localizedDescription)***********")
                    appError.message = error.localizedDescription
                    observer.on(.error(appError))
                }
            }
             return Disposables.create()
        }
    }
}
