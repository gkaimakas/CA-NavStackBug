//
//  NavigationStackScope.swift
//  Expenses
//
//  Created by George Kaimakas on 9/1/23.
//

import ComposableArchitecture

public func NavigationStackScope<
    ParentState,
    ParentAction,
    View: Equatable & Hashable
>(
    state toNavigationState: WritableKeyPath<ParentState, NavigationStackState<View>>,
    action toChildAction: CasePath<ParentAction, NavigationStackAction<View>>
) -> Scope<ParentState, ParentAction, NavigationStackReducer<View>> {
    
    Scope(
        state: toNavigationState,
        action: toChildAction,
        NavigationStackReducer.init
    )
}
