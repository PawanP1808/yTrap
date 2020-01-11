////
////  GeneralCache.swift
////  yTrap
////
////  Created by Pawan on 2020-01-11.
////  Copyright © 2020 SocialMusic. All rights reserved.
////
//
//import Foundation
//
//let personData = NSKeyedArchiver.archivedDataWithRootObject(newPerson)
//NSUserDefaults().setObject(personData, forKey: "personData")
//
//
////get your object from NSUserDefaults.
//if let loadedData = UserDefaults().dataForKey("personData") {
//    
//}
////
//    if let loadedPerson = NSKeyedUnarchiver.unarchiveObjectWithData(loadedData) as? [Person] {
//        loadedPerson[0].name   //"Leo"
//        loadedPerson[0].age    //45
//    }
//}
//
//
//class GeneralCache {
//    
//    func storeImg(forUrlString: String, img: UIImage){
//        let path = NSTemporaryDirectory().appending(UUID().uuidString)
//        let url = URL(fileURLWithPath: path)
//        
//        let data = img.jpegData(compressionQuality: 0.5)
//        try? data?.write(to:url)
//        
//        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]
//        
//        if(dict==nil){
//            dict = [String:String]()
//        }
//        dict![forUrlString] = path
//        UserDefaults.standard.set(dict, forKey: "ImageCache")
//    }
//    
//    func storeUserData
//    
//    func loadImage(fromUrlString image:String?, callback: @escaping ((_ success: Bool, _ image:UIImage?) -> ())){
//        guard let imageUrl = image else { return }
//        if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String] {
//            if let path = dict[imageUrl] {
//                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
//                    let img = UIImage(data: data)
//                    callback(true, img)
//                }
//            }
//        }
//        Alamofire.request(imageUrl).responseImage { response in
//            if let image = response.result.value {
//                self.storeImg(forUrlString: imageUrl, img: image)
//                callback(true,image)
//            }
//            callback(false,nil)
//        }
//    }
//
//    
//    
//}
