//
//  SearchResults.swift
//  Pods
//
//  Created by Adam Galloway on 10/9/15.
//
//

import Foundation

public final class SearchResults<T> {
    
    let results: [T]
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
    public func generate() -> IndexingGenerator<Array<T>> {
        return results.generate()
    }
}