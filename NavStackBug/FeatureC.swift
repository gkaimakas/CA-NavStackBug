//
//  FeatureC.swift
//  NavStackBug
//
//  Created by George Kaimakas on 13/1/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct FeatureCState: Hashable, Identifiable {
    var presentedView: FeatureCPresentedView? = nil
    var id: String
    
    var featureXState: FeatureX.State? = nil
    
    init(id: String) {
        self.id = id
    }
}

enum FeatureCPresentedView: Hashable, Identifiable {
    case featureX
    
    var id: Int { hashValue }
}

enum FeatureCAction {
    case onAppear
    
    case tappedToPresentFeatureX
    case featureX(FeatureX.Action)
    case dismissedPresentedView
}

struct FeatureC: ReducerProtocol {
    typealias State = FeatureCState
    typealias Action = FeatureCAction
    
    var body: some ReducerProtocolOf<Self> {
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
            
        case .tappedToPresentFeatureX:
            state.featureXState = .init(id: "featureX")
            state.presentedView = .featureX
            
        case .featureX:
            break
            
        case .dismissedPresentedView:
            state.featureXState = nil
            state.presentedView = nil
            
        }
        return .none
    }
}

struct FeatureCView: View {
    let store: StoreOf<FeatureC>
    
    @ObservedObject
    var viewStore: ViewStoreOf<FeatureC>
    
    var body: some View {
        VStack {
            
                Button(action: { viewStore.send(.tappedToPresentFeatureX) }) {
                    Text("present featureX")
                }
        }
        .sheet(
            item: viewStore.presentedView(),
            onDismiss: { viewStore.send(.dismissedPresentedView) },
            content: { view in
                switch view {
                case .featureX:
                    IfLetStore(
                        store.featureXStore(),
                        then: FeatureXView.init(store:)
                    )
                }
            }
        )
        .navigationTitle(viewStore.id)
    }
    
    init(store: StoreOf<FeatureC>) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
}

extension Store where State == FeatureC.State, Action == FeatureC.Action {
    func featureXStore(
    ) -> Store<FeatureX.State?, FeatureX.Action> {
        scope(
            state: \.featureXState,
            action: Action.featureX
        )
    }
}

extension ViewStore where ViewState == FeatureC.State, ViewAction == FeatureC.Action {
    
    func presentedView() -> Binding<FeatureCPresentedView?> {
        binding(
            get: \.presentedView,
            send: ViewAction.dismissedPresentedView
        )
    }
}


