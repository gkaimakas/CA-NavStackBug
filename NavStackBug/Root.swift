//
//  Root.swift
//  NavStackBug
//
//  Created by George Kaimakas on 13/1/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct RootState: Hashable {
    var featureAState: FeatureA.State?
}

enum Destination: Hashable {
    case featureB(FeatureB.State.ID)
    case featureC(FeatureC.State.ID, FeatureB.State.ID)
}

enum RootAction {
    case onAppear
    case featureA(FeatureA.Action)
    
}

struct Root: ReducerProtocol {
    typealias State = RootState
    typealias Action = RootAction
    
    var body: some ReducerProtocolOf<Self> {
        
        Reduce(_reduce(into:action: ))
            .ifLet(
                \.featureAState,
                 action: /Action.featureA,
                 then: FeatureA.init
            )
    }
    
    init() {}
    
    func _reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        switch action {
            
        case .onAppear:
            state.featureAState = .init(id: "featA")
            
        case .featureA:
            break
        }
        return .none
    }
}

struct RootView: View {
    let store: StoreOf<Root>
    
    @ObservedObject
    var viewStore: ViewStoreOf<Root>
    
    var body: some View {
        NavigationStack {
            IfLetStore(
                store.featureAStore(),
                then: FeatureAView.init(store:)
            )
            .navigationDestination(for: Destination.self) { view in
                switch view {
                case let .featureB(id):
                    IfLetStore(
                        store
                            .featureAStore()
                            .featureBStore(id: id),
                        then: FeatureBView.init(store:)
                    )
                    
                case let .featureC(id, featBId):
                    
                    IfLetStore(
                        store
                            .featureAStore()
                            .featureBStore(id: featBId)
                            .featureCStore(id: id),
                        then: FeatureCView.init(store:)
                    )
                }
            }
        }
        .onAppear { viewStore.send(.onAppear) }
    }
    
    init(store: StoreOf<Root>) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
}

extension Store where State == Root.State, Action == Root.Action {
    func featureAStore() -> Store<FeatureA.State?, FeatureA.Action> {
        scope(
            state: \.featureAState,
            action: Action.featureA
        )
    }
}
