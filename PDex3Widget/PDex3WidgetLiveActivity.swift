//
//  PDex3WidgetLiveActivity.swift
//  PDex3Widget
//
//  Created by Nils Müller on 30.11.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PDex3WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PDex3WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PDex3WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PDex3WidgetAttributes {
    fileprivate static var preview: PDex3WidgetAttributes {
        PDex3WidgetAttributes(name: "World")
    }
}

extension PDex3WidgetAttributes.ContentState {
    fileprivate static var smiley: PDex3WidgetAttributes.ContentState {
        PDex3WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PDex3WidgetAttributes.ContentState {
         PDex3WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PDex3WidgetAttributes.preview) {
   PDex3WidgetLiveActivity()
} contentStates: {
    PDex3WidgetAttributes.ContentState.smiley
    PDex3WidgetAttributes.ContentState.starEyes
}
