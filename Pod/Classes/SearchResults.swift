//
//  SearchResults.swift
//  Pods
//
//  Created by Adam Galloway on 10/9/15.
//
//

import Foundation

public final class SearchResults<T> {
    
    var results: [T] = []
    let total: Int64
    
    required public init?(results: [T], total: Int64) {
        self.results = results
        self.total = total
    }
    
    public func getResults() -> [T] {
        return self.results
    }
    
    public func getTotal() -> Int64 {
        return self.total
    }
    
}

extension SearchResults : SequenceType {
    // IndexingGenerator conforms to the GeneratorType protocol.
    public func generate() -> IndexingGenerator<Array<T>> {
        // Because Array already conforms to SequenceType,
        // you can just return the Generator created by your array.
        return results.generate()
    }
}
