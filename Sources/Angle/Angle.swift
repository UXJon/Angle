//
//  Angle.swift
//
//  Created by Jonathan Hull on 10/7/16.
//  Copyright © 2016 UX Detectives. All rights reserved.
//

import Foundation
import CoreGraphics

///Angle is a wrapper around a radian value which makes angles easier for humans to deal with.
public struct Angle:Equatable,Codable {
    ///The radian value of the angle. The angle is a thin wrapper around this value.
    public var radians:CGFloat
    
    ///The traditional quadrants of the plane.
    public enum Quadrant {
        case first,second,third,fourth
    }
    
    ///Init a new angle of zero degrees/radians
    public init() {
        self.radians = 0
    }
    
    ///Init a new angle with the given radian value
    public init(radians:CGFloat){
        self.radians = radians
    }
    
    ///Init a new angle with the given degree value
    public init(degrees:CGFloat) {
        self.radians = degrees * CGFloat.pi / 180
    }
    
    ///Init a new angle given an origin point and a target pt
    ///- Parameter origin: The CGPoint to use as the origin. Defaults to (0,0)
    ///- Parameter pt: The target CGPoint used to calculate the direction from the origin
    public init(origin:CGPoint = CGPoint.zero, pt:CGPoint) {
        self.radians = atan2(pt.y - origin.y, pt.x - origin.x)
    }
    
    ///Init a new angle given a number of eighth (45°) turns
    ///- Parameter eighthTurns: The number of 45° turns. Can be negative.
    public init(eighthTurns:Int){
        self.radians = CGFloat(eighthTurns) / 4.0 * CGFloat.pi
    }
    
    ///Init a new angle given a number of quarter (90°) turns
    ///- Parameter quarterTurns: The number of 90° turns. Can be negative.
    public init(quarterTurns:Int){
        self.radians = CGFloat(quarterTurns) / 2.0 * CGFloat.pi
    }
    
    ///Init a new angle given a number of revolutions. Can be used to give a percentage of a full turn.
    ///- Parameter revolutions: The number of turns
    public init(revolutions:CGFloat){
        self.radians = 2 * CGFloat.pi * revolutions
    }
    
    ///A zero degree angle
    public static let zero:Angle = Angle()
    ///A 45° angle
    public static let eighthTurn:Angle = Angle(eighthTurns: 1)
    ///A 90° angle
    public static let quarterTurn:Angle = Angle(quarterTurns: 1)
    ///A 135° angle
    public static let threeEighthTurn:Angle = Angle(eighthTurns: 3)
    ///A 180° straight angle
    public static let halfTurn:Angle = Angle(quarterTurns: 2)
    ///A  270° angle
    public static let threeQuarterTurn:Angle = Angle(quarterTurns: 3)
    ///A 360° angle
    public static let fullTurn:Angle = Angle(revolutions: 1)
    
    ///An angle with the given number of degrees
    public static func degrees(_ deg:CGFloat)->Angle {return Angle(degrees: deg)}
    ///An angle with the given radian value
    public static func radians(_ rad:CGFloat)->Angle {return Angle(radians: rad)}
    
    ///The angle expressed in degrees
    public var degrees:CGFloat {
        get{return radians * 180 / CGFloat.pi}
        set{self.radians = newValue * CGFloat.pi / 180}
    }
    
    ///The number of turns the angle makes.
    public var revolutions:CGFloat {
        get{return radians/(2 * CGFloat.pi)}
        set{self.radians = 2 * CGFloat.pi * newValue}
    }
    
    ///Returns true if the angle is zero
    public var isZero:Bool {return radians == 0}
    ///Returns true if the angle is negative (less than zero)
    public var isNegative:Bool {return radians < 0}
    ///Returns true if the angle is acute (less than 90°)
    public var isAcute:Bool {return radians < (CGFloat.pi/2)}
    ///Returns true if the angle is a right angle (90°)
    public var isRight:Bool {return radians == (CGFloat.pi/2)}
    ///Returns true if the angle is a straight angle (180°)
    public var isStraight:Bool {return radians == CGFloat.pi}
    ///Returns true if the angle is obtuse (between 90° and 180°)
    public var isObtuse:Bool {return radians > (CGFloat.pi/2) && radians < CGFloat.pi}
    
    ///Whether the angle is a reflex angle or not (greater than 180°)
    public var isReflex:Bool {return radians > CGFloat.pi}
    
    ///The quadrant that the angle lies in
    public var quadrant:Quadrant {
        if radians < .pi/2.0 {return .first}
        if radians < .pi {return .second}
        if radians < 3/2 * .pi {return .third}
        if radians < 2 * .pi {return .fourth}
        return self.normalized.quadrant
    }
    
    ///Returns an angle snapped to the desired resolution. Useful for user rotation of elements in the UI.
    ///- Parameter behavior: The behavior used to round/snap the angle.
    ///- Returns: An angle rounded by the given behavior.
    public func rounded(to behavior:RoundingBehavior = .nearestDegree) -> Angle {
        return behavior.rounded(self)
    }
    
    ///Defines how an Angle is rounded.
    public enum RoundingBehavior {
        ///Returns an angle snapped to the closest 0.5°
        case nearestHalfDegree
        ///Returns an angle snapped to the closest 1°
        case nearestDegree
        ///Returns an angle snapped to the closest 5°
        case nearestFiveDegrees
        ///Returns an angle snapped to the closest 45°
        case nearestEighthTurn
        ///Returns an angle snapped to the closest 90°
        case nearestQuarterTurn
        ///Returns an angle snapped by a custom function
        case custom((Angle)->Angle)
        
        ///Rounds a given angle.
        ///- Parameter angle: The angle to round
        ///- Returns: An angle rounded using the behavior.
        public func rounded(_ angle:Angle) -> Angle {
            switch self {
            case .nearestHalfDegree:
                return Angle(degrees: ((2 * angle.degrees).rounded(.toNearestOrEven))/2.0)
            case .nearestDegree:
                return Angle(degrees: angle.degrees.rounded(.toNearestOrEven))
            case .nearestFiveDegrees:
                return Angle(degrees: 5*((angle.degrees/5).rounded(.toNearestOrEven)))
            case .nearestEighthTurn:
                return Angle(eighthTurns: Int(((angle.radians * 4.0 / CGFloat.pi) + 0.5).rounded(.down)))
            case .nearestQuarterTurn:
                return Angle(quarterTurns: Int(((angle.radians * 2.0 / CGFloat.pi) + 0.5).rounded(.down)))
            case .custom(let fn):
                return fn(angle)
            }
        }
    }
    
    
    ///Normalizes angle to range of zero up to (but not including) one full turn.
    public var normalized:Angle {
        let twoPi:CGFloat = 2 * .pi
        if radians > 0 && radians < twoPi {return self}
        let rem = radians.truncatingRemainder(dividingBy: twoPi)
        if rem == 0 {return Angle.zero}
        if rem < 0 {return Angle(radians: twoPi + rem)}
        return Angle(radians: rem)
    }
    
    ///Normalizes angle to range of zero up to (but not including) one half turn. Use when there is 180° symmetry
    public var normalizedToHalf:Angle {
        if radians > 0 && radians < .pi {return self}
        let rem = radians.truncatingRemainder(dividingBy: .pi)
        if rem == 0 {return Angle.zero}
        if rem < 0 {return Angle(radians: .pi + rem)}
        return Angle(radians: rem)
    }
    
    ///Normalizes angle to range of zero up to (but not including) one quarter turn. Use when there is 90° symmetry
    public var normalizedToQuarter:Angle {
        let halfPi:CGFloat = .pi/2
        if radians > 0 && radians < halfPi {return self}
        let rem = radians.truncatingRemainder(dividingBy: halfPi)
        if rem == 0 {return Angle.zero}
        if rem < 0 {return Angle(radians: halfPi + rem)}
        return Angle(radians: rem)
    }
    
    ///Returns angle which when added to this angle is zero
    public var inverse:Angle { return Angle(radians: -radians)}
    
    ///Returns angle which when added to this angle is 90° (note: angles larger than 90° will have a negative compliment)
    public var compliment:Angle { return Angle(radians: CGFloat.pi/2 - radians) }
    
    ///Returns angle which when added to this angle is 180° (note: angles larger than 180° will have a negative suppliment)
    public var suppliment:Angle {
        return Angle(radians: CGFloat.pi - radians)
    }
    
    ///Returns whether two angles are equivalent (have the same effect)
    ///- Parameter other: The angle to check equivalence to.
    ///- Returns: True if the angles are equal when normalized
    public func isEquivalent(to other:Angle) -> Bool {
        return self.normalized == other.normalized
    }
    
    ///Rotates a point around the given point by the angle
    ///- Parameter point: The point to rotate
    ///- Parameter origin: The origin to rotate around
    ///- Returns: The rotated point
    public func rotate(_ point:CGPoint, around origin:CGPoint = CGPoint.zero) -> CGPoint {
        if self.isZero {return point}
        var t = CGAffineTransform(translationX: origin.x, y: origin.y)
        t = t.rotated(by: self.radians)
        t = t.translatedBy(x: -origin.x, y: -origin.y)
        return point.applying(t)
    }
    
}

extension Angle:CustomStringConvertible {
    public var description: String {
        return "\(self.degrees)°"
    }
}

extension Angle:Comparable {
    public static func < (lhs: Angle, rhs: Angle) -> Bool {
        return lhs.radians < rhs.radians
    }
}

extension Angle:AdditiveArithmetic {
    ///Adds two angles together
    public static func + (lhs:Angle, rhs:Angle)->Angle {
        return Angle(radians: lhs.radians + rhs.radians)
    }
    
    public static func += (lhs: inout Angle, rhs: Angle) {
        lhs.radians += rhs.radians
    }
    
    ///Subtracts one angle from another
    public static func - (lhs:Angle, rhs:Angle)->Angle {
        return Angle(radians: lhs.radians - rhs.radians)
    }

    public static func -= (lhs: inout Angle, rhs: Angle) {
        lhs.radians -= rhs.radians
    }
    
    public static prefix func - (base:Angle) -> Angle {
        return base.inverse
    }
}

extension Angle { //Scalar Math
    
    ///Scales an angle by a scalar value
    public static func * (scale:CGFloat, rhs:Angle)->Angle {
        return Angle(radians: scale * rhs.radians)
    }
    
    ///Scales an angle by a scalar value
    public static func * (lhs:Angle, scale:CGFloat)->Angle {
        return Angle(radians: scale * lhs.radians)
    }
    
    ///Scales an angle by an integer scalar value
    public static func * (scale:Int, rhs:Angle)->Angle {
        return Angle(radians: CGFloat(scale) * rhs.radians)
    }
    
    ///Scales an angle by an integer scalar value
    public static func * (lhs:Angle, scale:Int)->Angle {
        return Angle(radians: CGFloat(scale) * lhs.radians)
    }
    
    ///Divides an angle by a scalar value
    public static func / (lhs:Angle, scale:CGFloat)->Angle {
        return Angle(radians: lhs.radians / scale)
    }
}








