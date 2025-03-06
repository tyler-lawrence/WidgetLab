//
//  CoffeesConsumedWidget.swift
//  CoffeesConsumedWidget
//
//  Created by Tyler Lawrence1 on 3/6/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let dataController = DataController()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(coffeesConsumed: dataController.coffeeCount)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(coffeesConsumed: dataController.coffeeCount)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(coffeesConsumed: dataController.coffeeCount)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date = Date.now
    let coffeesConsumed: Int
}

struct CoffeesConsumedWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Coffees Consumed")
            Text(entry.coffeesConsumed.formatted())
        }
    }
}

struct CoffeesConsumedWidget: Widget {
    let kind: String = "CoffeesConsumedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(macOS 14.0, iOS 17.0, *) {
                CoffeesConsumedWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CoffeesConsumedWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    CoffeesConsumedWidget()
} timeline: {
    SimpleEntry(coffeesConsumed: 2)
    SimpleEntry(coffeesConsumed: 4)
}
