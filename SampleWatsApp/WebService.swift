//
//  WebService.swift
//  SampleWatsApp
//
//  Created by Developer on 29/09/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation

class WebService {
    
    class func get(completion: @escaping (NSDictionary)->()){
        
        guard let url = URL(string: "https://newsapi.org/v1/sources") else {
            
            print("URL Load Failed")
            return
            
        }
        
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil, let data = data else {
                print(" Response Error")
                return
            }
            
            
            do {
                
                guard let res = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary else {
                    print("Serialization Failed")
                    return
                }
                
                
                completion(res)
                
                
            }catch let err {
                
                print("Serialization Failed::"+err.localizedDescription)
                
            }
            
            
            
        }.resume()
        
        
    
        
        
    }
    
    
}
