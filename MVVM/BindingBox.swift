//
//  BindingBox.swift
//  MVVM
//
//  Created by Ikmal Azman on 12/05/2022.
//  Copyright © 2022 Eric Cerney. All rights reserved.
//

import Foundation

/// Generic class that allow to update UI when receive new set/update value
class BindingBox<T> {
    /// Generic listener for binding box
    typealias Listener = (T) -> Void
    /// Property for listener typealias with optional Listener type
    var listener : Listener?
    
    /// Variable for generic value
    var value : T {
        didSet {
            /// Active the listener object if being set/exist and pass the new value, allow to constantly listening with new value
            listener?(value)
        }
    }
    /// Default init method to initialise generic value
    init(_ value : T) {
        /// Set initialise value to value of the property
        self.value = value
    }
    /// Allow to bind value with UI and update itself with new value being set, optional listener allow to null the listener if we dont want to listen the changes anymore
    func bind(listener : Listener?) {
        self.listener = listener
        /// Immediately execute listener with current value  so UI can update immediately
        listener?(value)
    }
}
