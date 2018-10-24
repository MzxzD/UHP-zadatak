//
//  API.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire


class APIService {
    
    func fetchDataFromApI() -> Observable<DataWrapper<HNB>>{
        print("Downloading data...")
        
        let url = "http://hnbex.eu/api/v1/rates/daily/"
        
        return RxAlamofire
            .data(.get, url)
        
            .map({ (response) -> DataWrapper<HNB> in
                let decoder = JSONDecoder()
                print(response)
                var APIResponse: HNB = HNB()
                let responseJSON = response
                do {
                    let data = try decoder.decode(HNB.self, from: responseJSON)
                    APIResponse = data
                }catch let error {
                    print(error.localizedDescription)
                    return DataWrapper(data: APIResponse, error: error)
                }
                
                return DataWrapper(data:APIResponse, error: nil)
            })
    }
    
    
}
