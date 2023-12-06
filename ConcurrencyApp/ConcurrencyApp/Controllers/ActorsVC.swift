//
//  ActorsVC.swift
//  ConcurrencyApp
//
//  Created by Kate on 06/12/2023.
//

import UIKit

actor TemperatureLogger {
    let label: String
    var measurements: [Int]
    private(set) var max: Int
    private(set) var min: Int

    init(label: String, measurement: Int) {
        self.label = label
        self.measurements = [measurement]
        self.max = measurement
        self.min = measurement
    }
}

extension TemperatureLogger {
    func update(with measurement: Int) {
        measurements.append(measurement)
        if measurement > max {
            max = measurement
        } else if measurement < min {
            min = measurement
        }
    }
}

class ActorsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let logger = TemperatureLogger(label: "Outdoors", measurement: 0)
        
        Task {
            for item in 1...100 {
                await logger.update(with:item)
                print(await logger.max)
            }
        }
        Task {
            for item in 1...100 {
                await logger.update(with:-item)
                print(await logger.min)
            }
        }
//        Task {
//            for item in 101...200 {
//                await logger.update(with:item)
//                print(await logger.max)
//            }
//        }
//        Task {
//            for item in 101...200 {
//                await logger.update(with:-item)
//                print(await logger.min)
//            }
//        }
    }
}

