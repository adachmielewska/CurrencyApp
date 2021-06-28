//
//  CurrentWeatherService.swift
//  WeatherApp
//
//  Created by Adriana Chmielewska on 07/06/2021.
//  Copyright © 2021 Adriana Chmielewska. All rights reserved.
//

import Foundation
import Combine

protocol CurrentWeatherService {
    func fetchWeatherForZone(lat: Double, lon: Double, numberOfCities: Int, data: LoadableSubject<[LocationPresentationModel]>)
}

struct RealCurrentWeatherService: CurrentWeatherService {
    let webRepository: WebRepository

    init(webRepository: WebRepository) {
        self.webRepository = webRepository
    }

    func fetchWeatherForZone(lat: Double, lon: Double, numberOfCities: Int, data: LoadableSubject<[LocationPresentationModel]>) {
        let cancelBag = CancelBag()
        data.wrappedValue.setIsLoading(cancelBag: cancelBag)

        webRepository.call(endpoint: LocationWeatherEndpoints.currentWeather(lat: lat, long: lon, numberOfCities: numberOfCities))
            .sinkToLoadable { (result: Loadable<CurrentWeather>) in
                guard result.error == nil else {
                    data.wrappedValue = .failed(result.error!)
                    return
                }
                let locations = result.value?.list.map { LocationPresentationModel.fromDataModel($0) } ?? []
                data.wrappedValue = Loadable.loaded(locations)
        }.store(in: cancelBag)
    }
}
