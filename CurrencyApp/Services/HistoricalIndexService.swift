//
//  HistoricalIndexService.swift
//  CurrencyApp
//
//  Created by Adriana Chmielewska on 27/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import Combine

protocol HistoricalIndexService {
    func fetchIndex(data: LoadableSubject<[HistoricalPresentationModel]>)
}

struct RealHistoricalIndexService: HistoricalIndexService {
    let webRepository: WebRepository

    init(webRepository: WebRepository) {
        self.webRepository = webRepository
    }

    func fetchIndex(data: LoadableSubject<[HistoricalPresentationModel]>) {
        let cancelBag = CancelBag()
        data.wrappedValue.setIsLoading(cancelBag: cancelBag)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date.currentDate)
        let twoWeeks = Calendar.current.date(byAdding: .day, value: -14, to: Date.currentDate)
        webRepository.call(endpoint: BPIEndpoints.historicalIndex(startDate: dateFormatter.string(from: twoWeeks ?? Date.currentDate),
                                                                  endDate:  dateFormatter.string(from: yesterday ?? Date.currentDate)))
            .sinkToLoadable { (result: Loadable<HistoricalIndex>) in
                guard result.error == nil else { data.wrappedValue = .failed(result.error!); return }
                data.wrappedValue = .loaded(HistoricalPresentationModel.fromPresentationModel(item: result.value))
        }.store(in: cancelBag)
    }
}

struct StubHistoricalIndexService: HistoricalIndexService {
    func fetchIndex(data: LoadableSubject<[HistoricalPresentationModel]>) {}
}
