//
//  RunicListApp.swift
//  RunicList
//
//  Created by Marcos Garcia on 08/03/26.
//

import SwiftUI
import SwiftData

@main
struct RunicListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TaskItem.self)
    }
}
