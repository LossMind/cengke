//
//  class_Extension.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/21.
//  Copyright © 2017年 qlp. All rights reserved.
//

import Foundation
extension Int
{
    func hexedString() -> String
    {
        return NSString(format:"%02x", self) as String
    }
}

extension NSData
{
    func hexedString() -> String
    {
        var string = String()
        let unsafePointer = bytes.assumingMemoryBound(to: UInt8.self)
        for i in UnsafeBufferPointer<UInt8>(start:unsafePointer, count: length)
        {
            string += Int(i).hexedString()
        }
        return string
    }
    func MD5() -> NSData
    {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(unsafePointer))
        return NSData(data: result as Data)
    }
}

extension String
{
    func MD5() -> String
    {
        let data = (self as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return data.MD5().hexedString()
    }
    //单独的stringMD5加密
//    func md5()->String{
//        let str = input.cString(using: String.Encoding.utf8)
//        //let strLen = CC_LONG(input.lengthOfBytes(using: String.Encoding.utf8))
//        let strLen = CC_LONG(strlen(str))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        let hash = NSMutableString()
//        for i in 0..<digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        
//        result.deallocate(capacity: digestLen)
//        
//        return String(format: hash as String)
//    }
}
extension UIViewController
{
    func isMobileNumber(mobileNumber:String)->Bool{
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189,181(增加)
         */
        //NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        let MOBIL = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        //NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
        let CM:String = "^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$"
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        //NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189,181(增加)
         22         */
        //        NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
        let CT = "^1((33|53|8[019])[0-9]|349)\\d{7}$"
        
        let regexTestMobile = NSPredicate(format: "SELF MATCHES %@", MOBIL)
        let regexTestCM = NSPredicate(format:"SELF MATCHES %@", CM)
        let regexTestCU = NSPredicate(format:"SELF MATCHES %@", CU)
        let regexTestCT = NSPredicate(format:"SELF MATCHES %@", CT)
        if regexTestMobile.evaluate(with: mobileNumber)||regexTestCM.evaluate(with: mobileNumber)||regexTestCU.evaluate(with: mobileNumber)||regexTestCT.evaluate(with: mobileNumber){
            return true
        }else{
            return false
        }
        
        
    }
}

extension UILabel
{
    func fixLabel(frame:[CGFloat],font:CGFloat,text:String?,textCol:[CGFloat]?,backCol:[CGFloat]?,Aligent:NSTextAlignment){
        self.frame = CGRect.init(x: frame[0], y: frame[1], width: frame[2], height: frame[3])
        self.font = UIFont.systemFont(ofSize: font)
        self.text = text
        if textCol != nil {
         self.textColor = UIColor.init(red: (textCol?[0])!/250, green: (textCol?[1])!/250, blue: (textCol?[2])!/250, alpha:1)
        }
        if backCol != nil {
        self.backgroundColor = UIColor.init(red: (backCol?[0])!/250, green: (backCol?[1])!/250, blue: (backCol?[2])!/250, alpha: 1)
        }

        self.textAlignment = Aligent
    }
}
extension UIButton
{
    convenience init(type:UIButtonType?,frame: [CGFloat],backCol:[CGFloat]?,titleCol:UIColor?,font:CGFloat?,title:String?,img:String?) {
        if type != nil {
            self.init(type: type!)
        }else{
            self.init()
        }
        self.frame = CGRect.init(x: frame[0], y: frame[1], width: frame[2], height: frame[3])
        if backCol != nil {
            self.backgroundColor = UIColor.init(red: (backCol?[0])!/250, green: (backCol?[1])!/250, blue: (backCol?[2])!/250, alpha: 1)
        }
        if titleCol != nil {
            self.setTitleColor(titleCol, for: .normal)
        }
        if font != nil {
        self.titleLabel?.font = UIFont.systemFont(ofSize: font!)
        }
        if title != nil {
            self.setTitle(title, for: .normal)
        }
        if img != nil {
            self.setImage(UIImage.init(named: img!), for: .normal)
        }
    }
}
extension UIView
{
    func fixFrame(frame:[CGFloat]){
        self.frame = CGRect.init(x: frame[0], y: frame[1], width: frame[2], height: frame[3])
    }
    func fixBackCol(col:[CGFloat]){
        self.backgroundColor = UIColor.init(red: col[0], green: col[1], blue: col[2], alpha: 1)
    }
}
