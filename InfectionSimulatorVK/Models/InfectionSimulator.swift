//
//  InfectionSimulator.swift
//  InfectionSimulatorVK
//
//  Created by Denis on 10.05.2023.
//

import Foundation

enum State {
    case ill
    case healthy
}

final class InfectionSimulator {
    var people: [State] = []
    var quantity: Int
    var refreshRate: Int
    var infectionFactor: Int
    var width: Int
    
    init(quantity: Int, refreshRate: Int, infectionFactor: Int, width: Int) {
        for _ in 1...quantity {
            people.append(State.healthy)
        }
        self.quantity = quantity
        self.refreshRate = refreshRate
        self.infectionFactor = infectionFactor
        self.width = width
    }
    
    public func setQuantity(quantity: Int) {
        self.quantity = quantity
        people = []
        for _ in 1...quantity {
            people.append(State.healthy)
        }
    }
    
    public func calculateIll(callback: @escaping ()->Void) {
        var isAnyoneHealthy = true
        DispatchQueue.global(qos: .background).async { [weak self] in
            while isAnyoneHealthy {
                guard let self = self else { return }
                // здесь помечаем тех, кто заболеет под конец цикла подсчета
                var toBecomeIllIndices: Set<Int> = []
                // здесь храним контакты больного, и отбираем из них нужное число, которых нужно заразить
                var tempIndex: [Int] = []
                for (index, person) in people.enumerated() {
                    if person == .healthy { continue }
                    tempIndex.append(index - width)
                    tempIndex.append(index + width)
                    // если индекс не является крайним слева
                    if (index - 1) % width != width - 1 {
                        tempIndex.append(index - 1)
                    }
                    if (index + 1) % width != 0 {
                        tempIndex.append(index + 1)
                    }
                    tempIndex = tempIndex.filter { [weak self] in
                        $0 >= 0 && $0 < self!.quantity }
                    tempIndex.shuffle()
                    
                    let newCont = tempIndex.prefix(upTo: min(infectionFactor, tempIndex.count))
                    for a in newCont {
                        toBecomeIllIndices.insert(a)
                    }
                    tempIndex = []
                }
                for index in toBecomeIllIndices {
                    people[index] = .ill
                }
                toBecomeIllIndices = []
                // ждем обновления
                sleep(UInt32(refreshRate))
                if people.filter {$0 == .healthy}.count == 0 {
                    isAnyoneHealthy = false
                }
                // обновляем UI
                callback()
                
            }
        }
    }
}
