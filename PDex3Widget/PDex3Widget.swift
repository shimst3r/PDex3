//
//  PDex3Widget.swift
//  PDex3Widget
//
//  Created by Nils Müller on 30.11.24.
//

import CoreData
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    var randomPokemon: Pokemon {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        var results: [Pokemon] = []

        do {
            results = try context.fetch(request)
        } catch {
            print("[ERROR] Couldn't fetch: \(error)")
        }

        if let randomPokemon = results.randomElement() {
            return randomPokemon
        }
        return SamplePokemon.value
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), pokemon: SamplePokemon.value)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, pokemon: randomPokemon)
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, pokemon: randomPokemon)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let pokemon: Pokemon
}

struct PDex3WidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetSize
    var entry: Provider.Entry

    var body: some View {
        switch widgetSize {
        case .systemSmall:
            PokemonWidget(widgetSize: .small)
                .environmentObject(entry.pokemon)
        case .systemMedium:
            PokemonWidget(widgetSize: .medium)
                .environmentObject(entry.pokemon)
        case .systemLarge:
            PokemonWidget(widgetSize: .large)
                .environmentObject(entry.pokemon)
        default:
            PokemonWidget(widgetSize: .large)
                .environmentObject(entry.pokemon)
        }
    }
}

struct PDex3Widget: Widget {
    let kind: String = "PDex3Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PDex3WidgetEntryView(entry: entry)
                .containerBackground(Color(entry.pokemon.types!.first!.capitalized), for: .widget)
        }
    }
}

private extension ConfigurationAppIntent {
    static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemLarge) {
    PDex3Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, pokemon: SamplePokemon.value)
}
