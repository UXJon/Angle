//
//  File.swift
//  
//
//  Created by Jonathan Hull on 6/23/20.
//

import Foundation
import CoreGraphics

public extension CGContext {
    ///Adds an arc of a circle to the current path, specified with a radius and angles.
    ///- Parameter center: The center of the arc, in user space coordinates.
    ///- Parameter radius: The radius of the arc, in user space coordinates.
    ///- Parameter startAngle: The angle to the starting point of the arc from the positive x-axis.
    ///- Parameter endAngle: The angle to the end point of the arc from the positive x-axis.
    ///- Parameter clockwise: true to make a clockwise arc; false to make a counterclockwise arc.
    ///
    ///This method calculates starting and ending points using the radius and angles you specify, uses a sequence of cubic Bézier curves to approximate a segment of a circle between those points, and then appends those curves to the current path.
    ///
    ///The clockwise parameter determines the direction in which the arc is created; the actual direction of the final path is dependent on the current transformation matrix of the graphics context. In a flipped coordinate system (the default for UIView drawing methods in iOS), specifying a clockwise arc results in a counterclockwise arc after the transformation is applied.
    ///
    ///If the current path already contains a subpath, this method adds a line connecting the current point to the starting point of the arc. If the current path is empty, his method creates a new subpath whose starting point is the starting point of the arc. The ending point of the arc becomes the new current point of the path.
    func addArc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool) {
        self.addArc(center: center, radius: radius, startAngle: startAngle.radians, endAngle: endAngle.radians, clockwise: clockwise)
    }
    
    ///Rotates the user coordinate system in a context.
    ///- Parameter angle: The angle, in radians, by which to rotate the coordinate space of the specified context. Positive values rotate counterclockwise and negative values rotate clockwise.)
    ///
    ///The direction that the context is rotated may appear to be altered by the state of the current transformation matrix prior to executing this function. For example, on iOS, a UIView applies a transformation to the graphics context that inverts the Y-axis (by multiplying it by -1). Rotating the user coordinate system on coordinate system that was previously flipped results in a rotation in the opposite direction (that is, positive values appear to rotate the coordinate system in the clockwise direction).
    func rotate(by angle: Angle) {
        self.rotate(by: angle.radians)
    }
}

public extension CGMutablePath {
    ///Adds an arc of a circle to the path, specified with a radius and a difference in angle.
    ///- Parameter center: The center of the arc, in user space coordinates.
    ///- Parameter radius: The radius of the arc, in user space coordinates.
    ///- Parameter startAngle: The angle to the starting point of the arc from the positive x-axis.
    ///- Parameter delta: The difference between the starting angle and ending angle of the arc. A positive value creates a counter-clockwise arc (in user space coordinates), and vice versa.
    ///- Parameter transform:An affine transform to apply to the arc before adding to the path. Defaults to the identity transform if not specified.
    ///
    /// This method calculates starting and ending points using the radius and angles you specify, uses a sequence of cubic Bézier curves to approximate a segment of a circle between those points, and then appends those curves to the path.
    ///
    /// The delta parameter determines both the length of the arc the direction in which the arc is created; the actual direction of the final path is dependent on the transform parameter and the current transform of a context where the path is drawn. In a flipped coordinate system (the default for UIView drawing methods in iOS), specifying a clockwise arc results in a counterclockwise arc after the transformation is applied.
    ///
    /// If the path already contains a subpath, this method adds a line connecting the current point to the starting point of the arc. If the current path is empty, this method creates a new subpath whose starting point is the starting point of the arc. The ending point of the arc becomes the new current point of the path.
    func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: Angle, delta: Angle, transform: CGAffineTransform = .identity) {
        self.addRelativeArc(center: center, radius: radius, startAngle: startAngle.radians, delta: delta.radians, transform: transform)
    }

    ///Adds an arc of a circle to the path, specified with a radius and angles.
    ///- Parameter center: The center of the arc, in user space coordinates.
    ///- Parameter radius: The radius of the arc, in user space coordinates.
    ///- Parameter startAngle: The angle to the starting point of the arc from the positive x-axis.
    ///- Parameter endAngle: The angle to the end point of the arc from the positive x-axis.
    ///- Parameter clockwise: true to make a clockwise arc; false to make a counterclockwise arc.
    ///- Parameter transform: An affine transform to apply to the arc before adding to the path. Defaults to the identity transform if not specified.
    ///
    ///This method calculates starting and ending points using the radius and angles you specify, uses a sequence of cubic Bézier curves to approximate a segment of a circle between those points, and then appends those curves to the path.
    ///
    ///The clockwise parameter determines the direction in which the arc is created; the actual direction of the final path is dependent on the transform parameter and the current transform of a context where the path is drawn. In a flipped coordinate system (the default for UIView drawing methods in iOS), specifying a clockwise arc results in a counterclockwise arc after the transformation is applied.
    ///
    ///If the path already contains a subpath, this method adds a line connecting the current point to the starting point of the arc. If the current path is empty, this method creates a new subpath whose starting point is the starting point of the arc. The ending point of the arc becomes the new current point of the path.
    func addArc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool, transform: CGAffineTransform = .identity) {
        self.addArc(center: center, radius: radius, startAngle: startAngle.radians, endAngle: endAngle.radians, clockwise: clockwise, transform: transform)
    }
}

public extension CGAffineTransform {
    ///Returns an affine transformation matrix constructed from a rotation angle you provide.
    ///- Parameter angle: The angle by which this matrix rotates the coordinate system axes. In iOS, a positive value specifies counterclockwise rotation and a negative value specifies clockwise rotation. In macOS, a positive value specifies clockwise rotation and a negative value specifies counterclockwise rotation.
    ///
    ///This function creates a CGAffineTransform structure, which you can use (and reuse, if you want) to rotate a coordinate system. The matrix takes the following form:
    ///
    ///The actual direction of rotation is dependent on the coordinate system orientation of the target platform, which is different in iOS and macOS. Because the third column is always (0,0,1), the CGAffineTransform data structure returned by this function contains values for only the first two columns.
    ///
    ///These are the resulting equations used to apply the rotation to a point (x, y):
    ///
    ///If you want only to rotate an object to be drawn, it is not necessary to construct an affine transform to do so. The most direct way to rotate your drawing is by calling the function `rotate(by:)`.
    init(rotationAngle angle: Angle) {
        self.init(rotationAngle: angle.radians)
    }
    
    ///Returns an affine transformation matrix constructed by rotating an existing affine transform.
    ///- Parameter angle: The angle, in radians, by which to rotate the affine transform. In iOS, a positive value specifies counterclockwise rotation and a negative value specifies clockwise rotation. In macOS, a positive value specifies clockwise rotation and a negative value specifies counterclockwise rotation.
    ///
    ///You use this function to create a new affine transformation matrix by adding a rotation value to an existing affine transform. The resulting structure represents a new affine transform, which you can use (and reuse, if you want) to rotate a coordinate system.
    ///
    ///The actual direction of rotation is dependent on the coordinate system orientation of the target platform, which is different in iOS and macOS.
    func rotated(by angle:Angle) -> CGAffineTransform {
        self.rotated(by: angle.radians)
    }
}

public extension CGVector {
    
    ///Create a CGVector with the given length and Angle
    ///- Parameter length: The length of the vector. Defaults to 1.0 (a unit vector)
    ///- Parameter angle: The angle of the vector
    init(length:CGFloat = 1.0, angle:Angle){
        self.init(dx: length * cos(angle.radians), dy: length * sin(angle.radians))
    }
        
    ///Roates the vector by the given angle
    ///- Parameter angle: The Angle to rotate by
    ///- Returns: A CGVector which is the current vector rotated by the given angle
    func rotated(by angle:Angle) -> CGVector {
        let cosR = cos(angle.radians)
        let sinR = sin(angle.radians)
        return CGVector(dx: dx * cosR - dy * sinR, dy: dx * sinR + dy * cosR)
    }
    
}
