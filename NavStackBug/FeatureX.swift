//
//  FeatureX.swift
//  NavStackBug
//
//  Created by George Kaimakas on 13/1/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct FeatureXState: Hashable, Identifiable {
    var id: String
    
    var featureYState: FeatureY.State = .init(id: "feat-Y")
    
    init(id: String) {
        self.id = id
    }
}

enum FeatureXDestination: Hashable {
    case featureY
}

enum FeatureXAction {
    case onAppear
    case featureY(FeatureY.Action)
}

struct FeatureX: ReducerProtocol {
    typealias State = FeatureXState
    typealias Action = FeatureXAction
    
    var body: some ReducerProtocolOf<Self> {
        Scope(
            state: \.featureYState,
            action: /Action.featureY,
            FeatureY.init
        )
        
        Reduce(_reduce(into: action:))
    }
    
    init() {}
    
    func _reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        switch action {
            
        case .onAppear:
            break
            
        case .featureY:
            break
        }
        
        return .none
    }
}

struct FeatureXView: View {
    let store: StoreOf<FeatureX>
    
    @ObservedObject
    var viewStore: ViewStoreOf<FeatureX>
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(value: FeatureXDestination.featureY) {
                    Text("feat-Y")
                }
            }
            .navigationDestination(for: FeatureXDestination.self) { view in
                switch view {
                case .featureY:
                    FeatureYView(store: store.featureYStore())
//                    Text("help would be welcome")
                }
            }
            .navigationTitle(viewStore.id)
        }
        .onAppear { viewStore.send(.onAppear) }
    }
    
    init(store: StoreOf<FeatureX>) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
}

extension Store where State == FeatureX.State, Action == FeatureX.Action {
    func featureYStore() -> Store<FeatureY.State, FeatureY.Action> {
        scope(
            state: \.featureYState,
            action: Action.featureY
        )
    }
}
