//
//  NavigationStackAction.swift
//  Expenses
//
//  Created by George Kaimakas on 9/1/23.
//

import Foundation

public enum NavigationStackAction<View> where View: Equatable & Hashable {
    
    case stackChanged([View])
    case destinationRemoved(View)
    
    case push(View)
    case pushViews([View])
    case pop(View)
}
