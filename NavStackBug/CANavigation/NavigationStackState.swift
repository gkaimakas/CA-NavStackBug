//
//  NavigationStackState.swift
//  Expenses
//
//  Created by George Kaimakas on 9/1/23.
//

import Foundation

public struct NavigationStackState<View> where View: Equatable & Hashable {
    public var stack: [View]
    
    public init() {
        stack = []
    }
    
    public init(stack: [View]) {
        self.stack = stack
    }
    
    mutating
    func push(_ view: View) {
        stack.append(view)
    }
    
    mutating
    func push(views: [View]) {
        stack.append(contentsOf: views)
    }
    
    @discardableResult
    mutating
    func pop(_ view: View) -> View? {
        guard stack.last == view else { return nil }
        return stack.removeLast()
    }
}

extension NavigationStackState:
    Equatable,
    Hashable {
    
}
