//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 09.01.2023.
//

import Foundation

class NeuralNetworkManager {

    static let shared = NeuralNetworkManager()

    private var neuralNetwork: NeuralNetwork?

    private let epochsCount = 100000

    private init() {}

    static func convertX(driver: User, client: User) -> [Double] {
        guard let parameters = client.selectionParametrs, let taxiData = driver.taxiData else {
            return Array(repeating: 0, count: 6)
        }
        var result = [Double]()
        result.append(driver.rating / 5)
        result.append(Double(parameters.musicalPrioritet) * (taxiData.musicRating - 2.5) / 7.5)
        if let genderIndex = parameters.driverGenderIndex {
            let parameter = genderIndex == taxiData.genderIndex ? 1.0 : 0.0
            result.append(parameter / 2 + Double(parameters.genderPrioritet) / 6)
        } else {
            result.append(0.5)
        }
        if let minAge = parameters.driverMinAge, let maxAge = parameters.driverMaxAge {
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: taxiData.dateOfBirth, to: Date())
            let age = ageComponents.year!
            let parameter = minAge...maxAge ~= age ? 1.0 : 0.0
            result.append(parameter / 2 + Double(parameters.agePrioritet) / 6)
        } else {
            result.append(0.5)
        }
        result.append(Double(parameters.speedPrioritet) * (taxiData.speedRating) / 7.5)
        if let carColor = parameters.carColorIndex {
            let parameter = carColor == taxiData.yourCarColorIndex ? 1.0 : 0.0
            result.append(parameter / 2 + Double(parameters.colorPrioritet) / 6)
        } else {
            result.append(0.5)
        }
        return result
    }

    static func convertY(trip: Trip) -> Double {
        guard let ratingClient = trip.rating, let rating = trip.rating, let music = trip.music, let speed = trip.speed else {
            return 0
        }
        return (ratingClient + rating + music + speed) / 20
    }

    func train(x: [[Double]], y: [Double]) {
        let neuralNetwork = NeuralNetwork(inCount: x[0].count)
        for epoch in 0..<epochsCount {
            if epoch % 100 == 0 {
                print("EPOCH: \(epoch)")
            }
            for exampleIndex in 0..<x.count {
                let predict = neuralNetwork.predict(x: x[exampleIndex])
                let error = predict - y[exampleIndex]
                neuralNetwork.optimizer(x: x[exampleIndex], error: error)
            }
        }
        self.neuralNetwork = neuralNetwork
    }

    func predict(x: [Double]) -> Double {
        guard let neuralNetwork else {
            return 0
        }
        return neuralNetwork.predict(x: x)
    }

}
