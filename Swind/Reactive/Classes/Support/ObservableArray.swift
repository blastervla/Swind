//
//  ObservableArray.swift
//  ObservableArray
//
//  Created by Safx Developer on 2015/02/19.
//  Copyright (c) 2016 Safx Developers. All rights reserved.
//
import Foundation
import RxSwift

typealias ObservableArrayList = ObservableArray

public struct ArrayChangeEvent {
    public let insertedIndices: [Int]
    public let deletedIndices: [Int]
    public let updatedIndices: [Int]
    
    fileprivate init(inserted: [Int] = [], deleted: [Int] = [], updated: [Int] = []) {
        assert(inserted.count + deleted.count + updated.count > 0)
        insertedIndices = inserted
        deletedIndices = deleted
        updatedIndices = updated
    }
}

public struct ObservableArray<Element>: ExpressibleByArrayLiteral, ParentAware {
    var parentNotify: (() -> Void)?
    
    var isFirstOrderKind: Bool {
        return false
    }
    
    public typealias EventType = ArrayChangeEvent
    
    internal var eventSubject: PublishSubject<EventType>
    internal var elementsSubject: BehaviorSubject<[Element]>
    public var elements: [Element]
    
    public init() {
        elements = []
        elementsSubject = BehaviorSubject<[Element]>(value: elements)
        eventSubject = PublishSubject<EventType>()
    }
    
    public init(count: Int, repeatedValue: Element) {
        elements = Array(repeating: repeatedValue, count: count)
        elementsSubject = BehaviorSubject<[Element]>(value: elements)
        eventSubject = PublishSubject<EventType>()
    }
    
    public init<S : Sequence>(_ s: S) where S.Iterator.Element == Element {
        elements = Array(s)
        elementsSubject = BehaviorSubject<[Element]>(value: elements)
        eventSubject = PublishSubject<EventType>()
    }
    
    public init(arrayLiteral elements: Element...) {
        self.elements = elements
        elementsSubject = BehaviorSubject<[Element]>(value: elements)
        eventSubject = PublishSubject<EventType>()
    }
}

public extension ObservableArray {
    /// Provides a way of subscribing and manipulating rx results
    ///
    /// - Returns: An `Observable<[Element]>` containing all objects
    ///            of the array, that will emit a new value each time
    ///            an entry of the array changes.
    mutating func rx_elements() -> Observable<[Element]> {
        return self.elementsSubject
    }
    
    /// Provides a way of subscribing and manipulating rx results
    ///
    /// - Returns: An `Observable<EventType>` containing the `EventType`
    ///            of the last event, that will emit a new value each time
    ///            an entry of the array changes.
    mutating func rx_events() -> Observable<EventType> {
        return eventSubject
    }
    
    fileprivate func arrayDidChange(_ event: EventType) {
        self.elementsSubject.onNext(elements)
        eventSubject.onNext(event)
    }
}

extension ObservableArray: Collection {
    /// Wrapper property for the internal array's `capacity`
    public var capacity: Int {
        return elements.capacity
    }
    
    /*public var count: Int {
     return elements.count
     }*/
    
    /// Wrapper property for the internal array's `startIndex`
    public var startIndex: Int {
        return elements.startIndex
    }
    
    /// Wrapper property for the internal array's `endIndex`
    public var endIndex: Int {
        return elements.endIndex
    }
    
    /// Wrapper property for the internal array's `index(after: Int)`
    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }
}

extension ObservableArray: MutableCollection {
    /// Wrapper property for the internal array's
    /// `reserveCapacity(_ minimumCapacity: Int)`
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        elements.reserveCapacity(minimumCapacity)
    }
    
    /// Alias for the `append(_ newElement: )` function
    public mutating func add(_ newElement: Element) {
        append(newElement)
    }
    
    /// Adds a new element to the array, performing the necessary
    /// updates to all rx subscribers.
    ///
    /// - Parameter newElement: The new element that should be added
    public mutating func append(_ newElement: Element) {
        if var newElement = newElement as? ParentAware {
            newElement.parentNotify = self.parentNotify
        }
        elements.append(newElement)
        arrayDidChange(ArrayChangeEvent(inserted: [elements.count - 1]))
    }
    
    /// Adds a new elements to the array, performing the necessary
    /// updates to all rx subscribers.
    ///
    /// - Parameter newElements: The new elements that should be added
    public mutating func append<S : Sequence>(contentsOf newElements: S) where S.Iterator.Element == Element {
        elements.forEach { it in
            if var newElement = it as? ParentAware {
                newElement.parentNotify = self.parentNotify
            }
        }
        let end = elements.count
        elements.append(contentsOf: newElements)
        guard end != elements.count else {
            return
        }
        arrayDidChange(ArrayChangeEvent(inserted: Array(end..<elements.count)))
    }
    
    /// Alias for the `append(contentsOf: )` function.
    ///
    /// - Parameter newElement: The new element that should be added
    public mutating func addAll<C : Collection>(_ newElements: C) where C.Iterator.Element == Element {
        appendContentsOf(newElements)
    }
    
    /// Adds a new elements to the array, performing the necessary
    /// updates to all rx subscribers.
    ///
    /// - Parameter newElements: The new elements that should be added
    public mutating func appendContentsOf<C : Collection>(_ newElements: C) where C.Iterator.Element == Element {
        guard !newElements.isEmpty else {
            return
        }
        elements.forEach { it in
            if var newElement = it as? ParentAware {
                newElement.parentNotify = self.parentNotify
            }
        }
        let end = elements.count
        elements.append(contentsOf: newElements)
        arrayDidChange(ArrayChangeEvent(inserted: Array(end..<elements.count)))
    }
    
    /// Removes the last element of the array, if it exists, performing
    /// the necessary updates to all rx subscribers.
    @discardableResult public mutating func removeLast() -> Element? {
        guard !elements.isEmpty else { return nil }
        let e = elements.removeLast()
        arrayDidChange(ArrayChangeEvent(deleted: [elements.count]))
        return e
    }
    
    /// Inserts the element into the array at the given index (before the object
    /// that currently occupies that position) performing the necessary updates
    /// to all rx subscribers.
    ///
    /// - Parameter newElement: Element to insert
    /// - Parameter i: Index at which the new element should be inserted
    public mutating func insert(_ newElement: Element, at i: Int) {
        if var newElement = newElement as? ParentAware {
            newElement.parentNotify = self.parentNotify
        }
        elements.insert(newElement, at: i)
        arrayDidChange(ArrayChangeEvent(inserted: [i]))
    }
    
    /// Removes the element at the given index of the array performing the
    /// necessary updates to all rx subscribers.
    ///
    /// - Parameter i: Index of the element that should be removed.
    @discardableResult public mutating func remove(at index: Int) -> Element {
        let e = elements.remove(at: index)
        arrayDidChange(ArrayChangeEvent(deleted: [index]))
        return e
    }
    
    /// Removes all elements of the array, performing the
    /// necessary updates to all rx subscribers.
    ///
    /// - Parameter keepCapacity: `Bool` indicating whether the array
    ///                           should internally keep its capacity,
    ///                           which might be a useful optimization.
    public mutating func removeAll(_ keepCapacity: Bool = false) {
        guard !elements.isEmpty else {
            return
        }
        let es = elements
        elements.removeAll(keepingCapacity: keepCapacity)
        arrayDidChange(ArrayChangeEvent(deleted: Array(0..<es.count)))
    }
    
    /// Inserts the elements into the array at the given index (before the object
    /// that currently occupies that position) performing the necessary updates
    /// to all rx subscribers.
    ///
    /// - Parameter newElements: Elements to insert
    /// - Parameter i: Index at which the new elements should be inserted
    public mutating func insertContentsOf(_ newElements: [Element], atIndex i: Int) {
        guard !newElements.isEmpty else {
            return
        }
        elements.forEach { it in
            if var newElement = it as? ParentAware {
                newElement.parentNotify = self.parentNotify
            }
        }
        elements.insert(contentsOf: newElements, at: i)
        arrayDidChange(ArrayChangeEvent(inserted: Array(i..<i + newElements.count)))
    }
    
    /// Removes the last element from the array and returns it (if it exists),
    /// while performing the necessary updates to all rx subscribers.
    ///
    /// - Returns: The element occupying the last position of the array (or `nil`
    ///            if the array was empty)
    public mutating func popLast() -> Element? {
        let e = elements.popLast()
        if e != nil {
            arrayDidChange(ArrayChangeEvent(deleted: [elements.count]))
        }
        return e
    }
}

extension ObservableArray: RangeReplaceableCollection {
    /// Replaces the elements living in the given sub-range of indexes
    /// of the array with the new elements provided, performing all
    /// necessary updates to all rx subscribers.
    ///
    /// - Parameter subRange: The range of elements to be replaced
    /// - Parameter newCollection: The new elements to be used in replacement
    ///                            of the old ones.
    public mutating func replaceSubrange<C : Collection>(_ subRange: Range<Int>, with newCollection: C) where C.Iterator.Element == Element {
        newCollection.forEach { it in
            if var newElement = it as? ParentAware {
                newElement.parentNotify = self.parentNotify
            }
        }
        
        let oldCount = elements.count
        elements.replaceSubrange(subRange, with: newCollection)
        
        let first = subRange.lowerBound
        let newCount = elements.count
        let end = first + (newCount - oldCount) + subRange.count
        arrayDidChange(ArrayChangeEvent(inserted: Array(first..<end),
                                        deleted: Array(subRange.lowerBound..<subRange.upperBound)))
    }
}

extension ObservableArray: CustomDebugStringConvertible {
    public var description: String {
        return elements.description
    }
}

extension ObservableArray: CustomStringConvertible {
    public var debugDescription: String {
        return elements.debugDescription
    }
}

extension ObservableArray: Sequence {
    
    /// Function which provides access to individual array elements.
    /// Any new assignment will be treated as an _update_ if the index was
    /// already occupied, and as an _insertion_ if it was added on the
    /// last index. Performs any necessary updates to keep all rx subscribers
    /// notified of changes.
    ///
    /// - Returns: The element at the given index.
    public subscript(index: Int) -> Element {
        get {
            return elements[index]
        }
        set {
            if var newElement = newValue as? ParentAware {
                newElement.parentNotify = self.parentNotify
            }
            elements[index] = newValue
            if index == elements.count {
                arrayDidChange(ArrayChangeEvent(inserted: [index]))
            } else {
                arrayDidChange(ArrayChangeEvent(updated: [index]))
            }
        }
    }
    
    public subscript(bounds: Range<Int>) -> ArraySlice<Element> {
        get {
            return elements[bounds]
        }
        set {
            newValue.forEach { it in
                if var newElement = it as? ParentAware {
                    newElement.parentNotify = self.parentNotify
                }
            }
            elements[bounds] = newValue
            let first = bounds.lowerBound
            arrayDidChange(ArrayChangeEvent(inserted: Array(first..<first + newValue.count),
                                            deleted: Array(bounds.lowerBound..<bounds.upperBound)))
        }
    }
    
    /// - Returns: The last element in the array that meet the given condition (or `nil`
    ///            if none meet the condition).
    public func last(where condition: (Element) throws -> Bool) rethrows -> Element? {
        for element in reversed() {
            if try condition(element) { return element }
        }
        return nil
    }
    
    /// - Returns: The last element of the array, or `nil` if it's empty.
    public func last() -> Element? {
        return self.last { _ in true }
    }
}
