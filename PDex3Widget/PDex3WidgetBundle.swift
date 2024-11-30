//
//  PDex3WidgetBundle.swift
//  PDex3Widget
//
//  Created by Nils Müller on 30.11.24.
//

import WidgetKit
import SwiftUI

@main
struct PDex3WidgetBundle: WidgetBundle {
    var body: some Widget {
        PDex3Widget()
        PDex3WidgetControl()
        PDex3WidgetLiveActivity()
    }
}
