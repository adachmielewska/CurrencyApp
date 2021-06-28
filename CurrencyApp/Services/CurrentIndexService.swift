//
//  CurrentIndexService.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 25/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import Combine

protocol CurrentIndexService {
    func fetchCurrent(data: LoadableSubject<CurrentIndexPresentationModel>)
}

struct RealCurrentIndexService: CurrentIndexService {
    let webRepository: WebRepository

    init(webRepository: WebRepository) {
        self.webRepository = webRepository
    }

    func fetchCurrent(data: LoadableSubject<CurrentIndexPresentationModel>) {
        let cancelBag = CancelBag()
        data.wrappedValue.setIsLoading(cancelBag: cancelBag)
        webRepository.call(endpoint: BPIEndpoints.currentIndex)
            .sinkToLoadable { (result: Loadable<CurrentIndex>) in
                guard result.error == nil else { data.wrappedValue = .failed(result.error!); return }
                data.wrappedValue = .loaded(CurrentIndexPresentationModel.fromDataModel(result.value?.bpi))
        }.store(in: cancelBag)
    }
}
