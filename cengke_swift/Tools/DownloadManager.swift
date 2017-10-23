//
//  DownloadManager.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
enum HTTPRequestType {
    case GET
    case POST
}
class DownloadManager: AFHTTPSessionManager {
    static let sharedManager = DownloadManager()
    var emptyview:emptyView?
    func request(requestType: HTTPRequestType, urlString: String, parameters: [String: AnyObject]?,View:UIView, completion: @escaping (AnyObject?) -> ()) {
        
        //成功回调
        let success = { (task: URLSessionDataTask, json: Any)->() in
            if self.emptyview != nil {
                self.emptyview?.removeFromSuperview()
                self.emptyview = nil
            }
            completion(json as AnyObject?)
        }
        
        //失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            self.emptyview = emptyView.init(frame: View.bounds)
            self.emptyview?.refreshBlock = {[weak self] in
                self?.request(requestType: requestType, urlString: urlString, parameters: parameters, View: View, completion: completion)
            }
            View.addSubview(self.emptyview!)
            completion(nil)
        }
        
        if requestType == .GET {
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }



}
