//
//  FeatureY.swift
//  NavStackBug
//
//  Created by George Kaimakas on 13/1/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct FeatureYState: Hashable, Identifiable {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}

enum FeatureYAction {
    case onAppear
}

struct FeatureY: ReducerProtocol {
    typealias State = FeatureYState
    typealias Action = FeatureYAction
    
    var body: some ReducerProtocolOf<Self> {
        Reduce(_reduce(into: action:))
    }
    
    init() {}
    
    func _reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        .none
    }
}

struct FeatureYView: View {
    let store: StoreOf<FeatureY>
    
    @ObservedObject
    var viewStore: ViewStoreOf<FeatureY>
    
    var body: some View {
        Text(viewStore.id)
    }
    
    init(store: StoreOf<FeatureY>) {
        self.store = store
        self.viewStore = .init(store, observe: { $0 })
    }
}

