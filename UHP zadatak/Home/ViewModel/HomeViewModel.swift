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
    
    var downloadTrigger: ReplaySubject<Bool>
    var dataIsReady: PublishSubject<Bool>
    var HNBdata: HNB = []
    
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
    
}

protocol HomeViewModelProtocol {
    var downloadTrigger : ReplaySubject<Bool> {get}
    var dataIsReady : PublishSubject<Bool> {get}
    var HNBdata: HNB {get}
    func startDownload()
    func getDataFromApi() -> Disposable
}
