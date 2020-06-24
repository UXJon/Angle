# Angle

Angle is a wrapper around a radian angle value which makes angles much easier for humans to deal with and reason about.

Angles can be defined in degrees, radians, revolutions (percentage of a full turn), quarter turns, and eighth turns. Regardless of definition, it is always stored as radians.  Angles can be added together, subtracted from one another, or multiplied/divided by a scalar. They can also be snapped to the nearest half degree, 1°, 5°, or 45°

##Angle Creation

An angle can be easily created using the degree operator °

	let myAngle : Angle = 45°
	
You can also explicitly specify a radian or degree value:

	let radianAngle = Angle(radians: .pi/2.0)
	let degreeAngle = Angle(degrees: 45.0)
	
or using dot syntax:

	let radianAngle : Angle = .radians(.pi/2)
	let degreeAngle : Angle = .degrees(45.0)
	
It can also be useful to specify an angle as the number of revolutions. This can be thought of as a percentage of turns:

	let angle = Angle(revolutions: 0.5) //Half a turn
	
When manipulating graphics it can be useful to get an angle from two points (The origin defaults to .zero when omitted):

	let angle = Angle(origin: start, pt: end)
	
There are also a number of convenience initializers

	.zero //A zero angle
	.eighthTurn //A 45° angle
	.quarterTurn //A 90° angle
	.threeEighthTurn //A 135° angle
	.halfTurn //A straight (180°) angle
	.threeQuarterTurn //A 270° angle
	.fullTurn //A 360° angle
	
Finally you can specify a number of quarter or eighth turns:

	let fourtyFive = Angle(eighthTurns: 1)
	let right = Angle(quarterTurns: 1)
	

## Angle Properties

You can get and set an angle's radian, degree, or revolutions value:

	var angle = .quarterTurn
	print(angle.degrees) // 90°
	print(angle.radians) // .157079...
	print(angle.revolutions) // 0.25
	
You can also get angles which are related to a given angle

	angle.inverse //Angle which adds to zero
	angle.compliment //Angle which adds to 90°
	angle.suppliment //Angle which adds to 180°
	
Various properties of the angle can be explored:

	angle.isZero //True if the angle == 0
	angle.isNegative //True if the angle < 0
	angle.isAcute //True if the angle is < 90°
	angle.isRight //True if the angle == 90°
	angle.isStraight //True if the angle == 180°
	angle.isObtuse //True if the angle is between 90° and 180°
	angle.isReflex //True if the angle is > 180°
	angle.quadrant //The quadrant of the plane which the angle lies in
	
## Normalization

An angle can be normalized to fall in the 0 to 360° range

	angle.normalized
	
It can also be normalized to fall in the 0 to 180° range or 0 to 90° range

	angle.normalizedToHalf
	angle.normalizedToQuarter
	
You can check if two angles are equivalent (not necessarily equal):

	if angle.isEquivalent(to: other) {
	
	}
	
Two angles are equivalent if they are equal when normalized.

## Rounding

The value of an angle can be rounded to various resolutions. This is very useful to provide snapping behavior for user input of angles (e.g. while dragging to rotate an object).

	let rounded = angle.rounded(to: .nearestDegree)
	
The available rounding behaviors are:

	.nearestHalfDegree
	.nearestDegree //This is the default
	.nearestFiveDegrees
	.nearestEighthTurn
	.nearestQuarterTurn
	
A custom rounding behavior can also be provided:

	let customRounded = angle.rounded(to: .custom({angle in
		//Return rounded angle here...
	})
	
## Arithmetic

Angles can be added and subtracted from one another:

	let rotated = angle + 45°
	let another = rotated - 90°
	
They can also be multiplied and divided by a scalar:

	let double = 2.0 * angle
	let half = angle / 2.0
	

## Convenience Methods

A common graphical need is to rotate a point around another point by a given angle. There is a convenience method provided for this:

	let rotatedPt = angle.rotate(point, around: origin)
	
Zero is used as the origin if it is omitted.


You can define a CGVector using a length (defaults to 1.0) and Angle:

	let vector = CGVector(length: 1.0, angle: 45°)


Many methods in CoreGraphics have been given extensions which take Angles instead of (radian) floats to make these easier to reason about:

	let path = CGMutablePath()
	path.addArc(center: center, radius: 10.0, startAngle: 45°, endAngle: 90°, clockwise: false)
	



 
