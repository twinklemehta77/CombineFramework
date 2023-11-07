//
//  ApiCaller.swift
//  CombineFramework
//
//  Created by Twinkle Mehta on 06/11/23.
//

import Foundation
import Combine

class ApiCaller {
    static let shared = ApiCaller()
    
    func fetchCompanies() -> Future<[String], Error>{
        
        
            return Future { promixe in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    promixe(.success(["Apple","Orange","Banana","Pine Apple"]))
                }
                
                
            }
        
    }
}
