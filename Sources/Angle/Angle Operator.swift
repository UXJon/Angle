//
//  Angle Operator.swift
//
//  Created by Jonathan Hull on 6/23/20.
//

import Foundation
import CoreGraphics

postfix operator °

public postfix func ° (_ degrees:CGFloat)->Angle {
    return Angle(degrees: degrees)
}
public postfix func ° (_ degrees:Double)->Angle {
    return Angle(degrees: CGFloat(degrees))
}
public postfix func ° (_ degrees:Int)->Angle {
    return Angle(degrees: CGFloat(degrees))
}
