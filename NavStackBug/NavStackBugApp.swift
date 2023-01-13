//
//  NavStackBugApp.swift
//  NavStackBug
//
//  Created by George Kaimakas on 13/1/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct NavStackBugApp: App {
    var store: StoreOf<Root> = .init(
        initialState: .init(),
        reducer: Root()
    )
    
    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
