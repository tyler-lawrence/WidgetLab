//
//  ContentView.swift
//  CoffeeCounter
//
//  Created by Tyler Lawrence1 on 3/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var dataController = DataController()
    var body: some View {
        VStack {
            Text("Coffees Consumed")
                .font(.largeTitle)
            Text(dataController.coffeeCount.formatted())
                .contentTransition(.numericText(value: Double(dataController.coffeeCount)))
                .font(.title)
            HStack {
                Button("Drink 1 coffee") {
                    withAnimation {
                        dataController.incrementCoffeeCount(by: 1)
                    }
                }
                Button("Drink 2 coffees") {
                    withAnimation {
                        dataController.incrementCoffeeCount(by: 2)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
