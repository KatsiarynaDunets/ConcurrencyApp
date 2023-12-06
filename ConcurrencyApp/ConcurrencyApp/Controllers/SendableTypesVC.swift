//
//  SendableTypesVC.swift
//  ConcurrencyApp
//
//  Created by Kate on 06/12/2023.
//

import UIKit

/*
 Тип, который может быть передан из одного домена параллелизма в другой, известен как передаваемый тип. Например, он может быть передан в качестве аргумента при вызове метода субъекта или быть возвращен как результат задачи. В примерах, приведенных ранее в этой главе, не обсуждалась возможность отправки, поскольку в этих примерах используются простые типы значений, которые всегда безопасны для совместного использования для данных, передаваемых между доменами параллелизма. Напротив, некоторые типы небезопасны для передачи через домены параллелизма. Например, класс, который содержит изменяемые свойства и не сериализует доступ к этим свойствам, может привести к непредсказуемым и неправильным результатам при передаче экземпляров этого класса между различными задачами.

 Вы помечаете тип как доступный для отправки, объявляя соответствие Sendable протоколу. У этого протокола нет никаких требований к коду, но у него есть семантические требования, которые обеспечивает Swift.
 
 Некоторые типы всегда доступны для отправки, например, структуры, которые имеют только свойства, доступные для отправки, и перечисления, которые имеют только связанные с отправкой значения.
 */

actor TemperatureLogger2 {
    
    let label: String
    
    private(set) var max: Int
    private(set) var min: Int
    
    private(set) var randomArray = [TemperatureRandom]()
    private(set) var randomArray2 = [TemperatureRandom2]()

    init(label: String, measurement: Int) {
        self.label = label
        self.max = measurement
        self.min = measurement
    }
    
    func addTemperature(from temperatureRandom: TemperatureRandom) {
        update(with: temperatureRandom)
    }
    
    func addTemperature(from temperatureRandom: TemperatureRandom2) {
        update(with: temperatureRandom)
    }
}

struct TemperatureRandom: Sendable {
    var measurement: Int {
        Int.random(in: -100...100)
    }
}

/// 1
final class TemperatureRandom2: Sendable {
    var measurement: Int {
        Int.random(in: -100...100)
    }
}

/// 2
/*
final class TemperatureRandom2: @unchecked Sendable {

    private var measurement: Int
    let queue = DispatchQueue(label: "queue")
    
    init(measurement: Int) {
        self.measurement = measurement
    }
    
    func updateMeasurement(temp: Int) {
        queue.async {
            self.measurement = temp
        }
    }
    
    func getMeasurement() {
        queue.async {
            print(self.measurement)
        }
    }
    
}
 */

class SendableTypesVC: UIViewController {
    
    let logger = TemperatureLogger2(label: "Logger2", measurement: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            for _ in 0...100 {
                await logger.addTemperature(from: TemperatureRandom2())
                print(await logger.max)
                print(await logger.min)
            }
        }
        Task {
            for _ in 0...100 {
                await logger.addTemperature(from: TemperatureRandom2())
                print(await logger.max)
                print(await logger.min)
            }
        }
        
    }
}

extension TemperatureLogger2 {
    func update(with temperatureRandom: TemperatureRandom) {
        self.randomArray.append(temperatureRandom)
        if temperatureRandom.measurement > max {
            max = temperatureRandom.measurement
        } else if temperatureRandom.measurement < min {
            min = temperatureRandom.measurement
        }
    }
    
    func update(with temperatureRandom: TemperatureRandom2) {
        self.randomArray2.append(temperatureRandom)
        if temperatureRandom.measurement > max {
            max = temperatureRandom.measurement
        } else if temperatureRandom.measurement < min {
            min = temperatureRandom.measurement
        }
    }
}

