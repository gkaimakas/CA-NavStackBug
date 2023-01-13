//
//  FeatureA.swift
//  NavStackBug
//
//  Created by George Kaimakas on 13/1/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct FeatureAState: Hashable, Identifiable {
    var id: String
    
    var featureBStates: IdentifiedArrayOf<FeatureB.State> = .init()
    
    init(id: String) {
        self.id = id
    }
}

enum FeatureAAction {
    case onAppear
    case featureB(id: FeatureB.State.ID, action: FeatureB.Action)
}

struct FeatureA: ReducerProtocol {
    typealias State = FeatureAState
    typealias Action = FeatureAAction
    
    var body: some ReducerProtocolOf<Self> {
        Reduce(_reduce(into: action:))
            .forEach(
                \.featureBStates,
                 action: /Action.featureB(id:action:),
                 FeatureB.init
            )
    }
    
    init() {}
    
    func _reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            state.featureBStates = .init(uniqueElements: [
                .init(id: "featB-1"),
                .init(id: "featB-2"),
                .init(id: "featB-3"),
                .init(id: "featB-4"),
            ])
            
        case .featureB:
            break
        }
        
        return .none
    }
}

struct FeatureAView: View {
    let store: StoreOf<FeatureA>
    
    @ObservedObject
    var viewStore: ViewStoreOf<FeatureA>
    
    var body: some View {
        List {
            ForEachStore(
                store.scope(
                    state: \.featureBStates,
                    action: FeatureAAction.featureB(id:action:)),
                content: { childStore in
                    NavigationLink(value: Destination.featureB(ViewStore(childStore).id)) {
                        Text(ViewStore(childStore).id)
                    }
                }
            )
        }
        .onAppear { viewStore.send(.onAppear) }
        .navigationTitle(viewStore.id)
    }
    
    init(store: StoreOf<FeatureA>) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
}

extension Store where State == FeatureA.State, Action == FeatureA.Action {
    func featureBStore(
        id: FeatureB.State.ID
    ) -> Store<FeatureB.State?, FeatureB.Action> {
        scope(
            state: { $0.featureBStates[id: id] },
            action: { FeatureAAction.featureB(id: id, action: $0) }
        )
    }
}

extension Store where State == FeatureA.State?, Action == FeatureA.Action {
    func featureBStore(
        id: FeatureB.State.ID
    ) -> Store<FeatureB.State?, FeatureB.Action> {
        scope(
            state: { $0?.featureBStates[id: id] },
            action: { FeatureAAction.featureB(id: id, action: $0) }
        )
    }
}
