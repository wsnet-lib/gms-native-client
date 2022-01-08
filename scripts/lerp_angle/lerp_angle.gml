/**
 * Lerp between two angles, according to the specified amount
 */
function lerp_angle(currentAngle, targetAngle, turnSpeed) {
	var diff = angle_difference(currentAngle, targetAngle);
	return currentAngle - min(abs(diff), turnSpeed) * sign(diff);
}
