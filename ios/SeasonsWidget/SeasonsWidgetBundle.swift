//
//  SeasonsWidgetBundle.swift
//  Entry point for the widget extension. Declares every widget type
//  the extension provides — right now just `SeasonsWidget`.
//

import SwiftUI
import WidgetKit

@main
struct SeasonsWidgetBundle: WidgetBundle {
    var body: some Widget {
        SeasonsWidget()
    }
}
