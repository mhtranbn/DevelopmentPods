/**
 @file      Extensions.swift
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

import Foundation

#if (arch(i386) || arch(x86_64)) && os(iOS)
public let DEVICE_IS_SIMULATOR = true
#else
public let DEVICE_IS_SIMULATOR = false
#endif

public extension Array {
    
    func enumeratedBackward(_ block: (Element, Int) -> Void) {
        for i in stride(from: self.count - 1, to: -1, by: -1) {
            block(self[i], i)
        }
    }
    
    /**
     Remove all items from array if item == given item
     
     - parameter element: object to compare
     
     - returns: Number of removed items
     */
    mutating func remove<T: Equatable>(_ item: T) -> Int {
        var result = 0
        enumeratedBackward { (element, index) in
            if let e = element as? T, e == item {
                result += 1
                self.remove(at: index)
            }
        }
        return result
    }
    
    /**
     Remove all items from array if item === given item
     
     - parameter item: object to compare
     
     - returns: Number of removed items
     */
    mutating func removeRef<T: AnyObject>(_ item: T) -> Int {
        var result = 0
        enumeratedBackward { (element, index) in
            if let e = element as? T, e === item {
                result += 1
                self.remove(at: index)
            }
        }
        return result
    }
    
    func containsRef<T: AnyObject>(_ item: T) -> Bool {
        for element in self {
            if let e = element as? T, e === item {
                return true
            }
        }
        return false
    }
    
}

public extension String {
    
    /**
     Shorthand to access character of string. Set nil to remove character, set a character to replace.
     
     - parameter i: Index of character, must be inside range 0...charsCount
     
     - returns: Character at given index
     */
    subscript (i: Int) -> Character? {
        get {
            if i < self.count {
                let index = self.index(self.startIndex, offsetBy: i)
                return self[index]
            } else {
                return nil
            }
        }
        set (value) {
            if i < self.count {
                let index = self.index(self.startIndex, offsetBy: i)
                if let val = value {
                    let s = String(val)
                    self.replaceSubrange(index ..< self.index(index, offsetBy: 1), with: s)
                } else {
                    self.remove(at: index)
                }
            }
        }
    }
    
    /**
     Shorthand to access substring. Set nil to remove substring, set a string to replace
     
     - parameter index:  Start index of range, must be inside range 0..charsCount
     - parameter length: Length of range, index + length must inside range 0..charsCount
     
     - returns: String of given range
     */
    subscript (index: Int, length: Int) -> String? {
        get {
            if index < self.count && (index + length) <= self.count {
                let start = self.index(self.startIndex, offsetBy: index)
                let end = self.index(start, offsetBy: length)
                return String(self[start ..< end])
            } else {
                return nil
            }
        }
        set (value) {
            if index < self.count && (index + length) <= self.count {
                let start = self.index(self.startIndex, offsetBy: index)
                let end = self.index(start, offsetBy: length)
                let range = start ..< end
                if let val = value {
                    self.replaceSubrange(range, with: val)
                } else {
                    self.removeSubrange(range)
                }
            }
        }
    }
    
}

public extension String {
    
    init?(_ object: Any?) {
        if let s = object as? String {
            self = s
        } else if let obj = object {
            self = "\(obj)"
        } else {
            return nil
        }
    }
    
    init(_ bool: Bool) {
        self = bool ? "1" : "0"
    }
    
}

public extension Int {
    
    init?(_ object: Any?) {
        if let int = object as? Int {
            self = int
        } else if let num = object as? NSNumber {
            self = num.intValue
        } else if let s = object as? String, let int = Int(s) {
            self = int
        } else {
            return nil
        }
    }
    
    init(_ bool: Bool) {
        self = bool ? 1 : 0;
    }
    
}

public extension Bool {
    
    /// Init Bool from any type of input:
    ///   - Bool: default init
    ///   - NSNumber: init from NSNumber.boolValue
    ///   - String: init true if string is "true", "yes"; false if string is "false", "no";
    /// if string can be converted to Int so init with value of string != 0; other cases init with checking string length
    ///   - Int, Float, Double, CGFloat: init with value != 0
    ///   - Other cases: init with input object != nil
    ///
    /// - parameter value: Value
    ///
    /// - returns: depend on input
    init(_ value: Any?) {
        if let bool = value as? Bool {
            self.init(bool)
        } else if let num = value as? NSNumber {
            self.init(num.boolValue)
        } else if let s = value as? String {
            let lower = s.lowercased()
            if lower == "true" || lower == "yes" {
                self.init(true)
            } else if lower == "false" || lower == "no" {
                self.init(false)
            } else if let int = Int(s) {
                self.init(int != 0)
            } else {
                self.init(s.count > 0)
            }
        } else if let num = value as? Int {
            self.init(num != 0)
        } else if let num = value as? Float {
            self.init(num != 0)
        } else if let num = value as? Double {
            self.init(num != 0)
        } else if let num = value as? CGFloat {
            self.init(num != 0)
        } else {
            self.init(value != nil)
        }
    }
    
    func toStringNum() -> String {
        return self ? "1" : "0"
    }
    
    func toStringJSON() -> String {
        return self ? "true" : "false"
    }
    
    func toStringObjC() -> String {
        return self ? "YES" : "NO"
    }
    
}
