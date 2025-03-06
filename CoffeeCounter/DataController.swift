//
//  DataController.swift
//  CoffeeCounter
//
//  Created by Tyler Lawrence1 on 3/4/25.
//

import Foundation
import SwiftUI

@Observable
class DataController {
    // While force unwrapping generally isn't preferred, I don't mind it in this conxext because it's signaling to me as the developer that something is wrong with my data storage, which is an important feature of this app
    let defaults = UserDefaults(suiteName: "group.com.academy.CoffeeCounter")!
    var coffeeCount: Int {
        /*
         The getters and setters are used because @Observable macro doesn't support use of @AppStorage.
         this is what's happening behind the scenes of @AppStorage
         
         googled: "SwiftUI @AppStorage with @Observable"
         source: https://stackoverflow.com/questions/76606977/swift-is-there-any-way-to-use-appstorage-with-observable
         */
        get {
            access(keyPath: \.coffeeCount)
            return defaults.integer(forKey: "coffeeCount")
        }
        set {
            withMutation(keyPath: \.coffeeCount) {
                defaults.set(newValue, forKey: "coffeeCount")
            }
        }
    }

    func incrementCoffeeCount(by amount: Int) {
        coffeeCount += amount
    }
}
