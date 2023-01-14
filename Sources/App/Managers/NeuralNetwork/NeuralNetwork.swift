//
//  File.swift
//  
//
//  Created by Anatoliy Khramchenko on 09.01.2023.
//

import Foundation

class NeuralNetwork {

    private var weights: [Double]
    private var b = 0.1

    private let learningRate = 0.2

    init(inCount: Int) {
        self.weights = Array(repeating: 0.5, count: inCount)
    }

    func predict(x: [Double]) -> Double {
        if x.count != weights.count {
            return 0
        }
        var sum = 0.0
        for elementIndex in 0..<x.count {
            sum += weights[elementIndex] * x[elementIndex]
        }
        return sigmoid(sum + b)
    }

    func optimizer(x: [Double], error: Double) {
        if x.count != weights.count {
            return
        }
        for elementIndex in 0..<x.count {
            weights[elementIndex] -= error * x[elementIndex] * learningRate
        }
        b -= error * learningRate
    }

    private func sigmoid(_ x: Double) -> Double {
        return 1 / (1 + exp(-x))
    }

}
