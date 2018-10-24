//
//  HomeViewModel.swift
//  UHP zadatak
//
//  Created by Mateo Doslic on 24/10/2018.
//  Copyright © 2018 Mateo Doslic. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HomeViewModel: HomeViewModelProtocol {
    var fromValue: String = .empty
    var toValue: String = .empty
    var downloadTrigger: ReplaySubject<Bool>
    var dataIsReady: PublishSubject<Bool>
    var HNBdata: HNB = []
    let rateArray: [String] = ["Selling Rate", "Buying Rate", "Median Rate"]
    
    init() {
        self.dataIsReady = PublishSubject<Bool>()
        self.downloadTrigger = ReplaySubject<Bool>.create(bufferSize: 1)
    }
    
    func getDataFromApi() -> Disposable {
        let downloadObserverTrigger = downloadTrigger.flatMap { (_) -> Observable<DataWrapper<HNB>> in
            return APIService().fetchDataFromApI()
        }
            
            return downloadObserverTrigger
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [unowned self](downloadedData) in
                    self.HNBdata.removeAll()
                    if downloadedData.error == nil {
                        self.HNBdata = downloadedData.data!
                        self.dataIsReady.onNext(true)
                    } else {
                        print("")
                    }
                })
    }
    
    func startDownload() {
        downloadTrigger.onNext(true)
    }
    
    
    func calculate(from: String, to: String, value: String, rate: String) -> String {
        var result: String = .empty
        var number: Double!
        if (from == "HRK") {
            for element in HNBdata {
                if (element.currencyCode == to) {
                    var numberToCalculate: String = .empty
                    guard let valueNumber = Double(value) else {return ""}
                    if (rate == "Selling Rate"){
                        numberToCalculate = element.sellingRate
                    }else if (rate == "Buying Rate"){
                        numberToCalculate = element.buyingRate
                    }else {
                        numberToCalculate = element.medianRate
                    }
                    guard let rateNumber = Double(numberToCalculate) else {return ""}
                    number = valueNumber / rateNumber
                }
            }
        }else {
            for element in HNBdata {
                if (element.currencyCode == from) {
                    var numberToCalculate: String = .empty
                    guard let valueNumber = Double(value) else {return ""}
                    if (rate == "Selling Rate"){
                        numberToCalculate = element.sellingRate
                    }else if (rate == "Buying Rate"){
                        numberToCalculate = element.buyingRate
                    }else {
                        numberToCalculate = element.medianRate
                    }
                    guard let rateNumber = Double(numberToCalculate) else {return ""}
                    number = valueNumber * rateNumber
                }
            }
        }
        result = String(format:"%f", number)
        return result
    }
    
}

protocol HomeViewModelProtocol {
    var downloadTrigger : ReplaySubject<Bool> {get}
    var dataIsReady : PublishSubject<Bool> {get}
    var HNBdata: HNB {get}
    func startDownload()
    func getDataFromApi() -> Disposable
    var fromValue: String {get set}
    var toValue: String {get set}
    func calculate(from: String, to: String, value: String, rate: String) -> String
    var rateArray: [String] {get}
}
