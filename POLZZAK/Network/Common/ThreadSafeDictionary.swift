//
//  ThreadSafeDictionary.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/30.
//

import Foundation

final class ThreadSafeDictionary<T, U> where T: Hashable {
    private let serialQueue = DispatchQueue(label: "ThreadSafeDictionaryQueue")
    private var _value: [T: U]
    
    init() {
        self._value = [:]
    }
    
    subscript(_ key: T) -> U? {
        get {
            serialQueue.sync {
                _value[key]
            }
        }
        set {
            serialQueue.async {
                self._value[key] = newValue
            }
        }
    }
}
