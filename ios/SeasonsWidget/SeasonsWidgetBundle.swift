//
//  SeasonsWidgetBundle.swift
//  SeasonsWidget
//
//  Entry point. Only one widget type — the home/lock-screen widget.
//  (Xcode's template adds Control Center + Live Activity variants;
//  we don't use them for this app.)
//

import SwiftUI
import WidgetKit

@main
struct SeasonsWidgetBundle: WidgetBundle {
    var body: some Widget {
        SeasonsWidget()
    }
}
