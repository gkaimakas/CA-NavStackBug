//
//  NavigationStackReducer.swift
//  Expenses
//
//  Created by George Kaimakas on 9/1/23.
//

import ComposableArchitecture
import Foundation

public struct NavigationStackReducer<View: Equatable & Hashable>: ReducerProtocol {
    
    public typealias State = NavigationStackState<View>
    public typealias Action = NavigationStackAction<View>
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce(_reduce(into:action:))
    }
    
    public init() {}
    
    func _reduce(
        into state: inout State,
        action: Action
    ) -> EffectTask<Action> {
        
        switch action {
        case let .stackChanged(newStack):
            let oldStack = state.stack
            state.stack = newStack
            
            let effects = newStack
                .difference(from: oldStack)
                .removals
                .compactMap(toRemovedElementEffect)
            
            return .concatenate(effects)
            
        case let .push(view):
            state.push(view)
            
        case let .pushViews(views):
            state.push(views: views)
            
        case let .pop(view):
            state.pop(view)
            
        case .destinationRemoved:
            break
        }
        
        return .none
    }
    
    func toRemovedElementEffect(
        _ change: CollectionDifference<View>.Change
    ) -> EffectTask<Action>? {
        switch change {
        case let .remove(_, element, _):
            return .task(operation: { .destinationRemoved(element) })
            
        case _:
            return nil
        }
    }
}

