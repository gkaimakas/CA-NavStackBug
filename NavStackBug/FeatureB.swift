//
//  FeatureB.swift
//  NavStackBug
//
//  Created by George Kaimakas on 13/1/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct FeatureBState: Hashable, Identifiable {
    var id: String
    
    var featureCStates: IdentifiedArrayOf<FeatureC.State> = .init()
    
    init(id: String) {
        self.id = id
    }
}

enum FeatureBAction {
    case onAppear
    case featureC(id: FeatureC.State.ID, action: FeatureC.Action)
}

struct FeatureB: ReducerProtocol {
    typealias State = FeatureBState
    typealias Action = FeatureBAction
    
    var body: some ReducerProtocolOf<Self> {
        Reduce(_reduce(into: action:))
            .forEach(
                \.featureCStates,
                 action: /Action.featureC(id:action:),
                 FeatureC.init
            )
    }
    
    init() {}
    
    func _reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            state.featureCStates = .init(uniqueElements: [
                .init(id: "featC-1"),
                .init(id: "featC-2"),
                .init(id: "featC-3"),
                .init(id: "featC-4"),
            ])
            
        case .featureC:
            break
        }
        
        return .none
    }
}

struct FeatureBView: View {
    let store: StoreOf<FeatureB>
    
    @ObservedObject
    var viewStore: ViewStoreOf<FeatureB>
    
    var body: some View {
        List {
            ForEachStore(
                store.scope(
                    state: \.featureCStates,
                    action: FeatureBAction.featureC(id:action:)),
                content: { childStore in
                    NavigationLink(value: Destination.featureC(ViewStore(childStore).id, viewStore.id)) {
                        Text(ViewStore(childStore).id)
                    }
                }
            )
        }
        .onAppear { viewStore.send(.onAppear) }
        .navigationTitle(viewStore.id)
    }
    
    init(store: StoreOf<FeatureB>) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
}

extension Store where State == FeatureB.State, Action == FeatureB.Action {
    func featureCStore(
        id: FeatureC.State.ID
    ) -> Store<FeatureC.State?, FeatureC.Action> {
        scope(
            state: { $0.featureCStates[id: id] },
            action: { FeatureBAction.featureC(id: id, action: $0) }
        )
    }
}

extension Store where State == FeatureB.State?, Action == FeatureB.Action {
    func featureCStore(
        id: FeatureC.State.ID
    ) -> Store<FeatureC.State?, FeatureC.Action> {
        scope(
            state: { $0?.featureCStates[id: id] },
            action: { FeatureBAction.featureC(id: id, action: $0) }
        )
    }
}

