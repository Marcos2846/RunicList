//
//  ContentView.swift
//  RunicList
//
//  Created by Marcos Garcia on 08/03/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TaskListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}

