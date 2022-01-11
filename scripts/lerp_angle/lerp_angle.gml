/**
 * Lerp between two angles, according to the specified amount
 *
 * @param {Number} currentAngle
 * @param {Number} targetAngle
 * @param {Number} turnSpeed
 *
 * @return {Number} angle
 */
function lerp_angle(currentAngle, targetAngle, turnSpeed) {
	var diff = angle_difference(currentAngle, targetAngle);
	return currentAngle - min(abs(diff), turnSpeed) * sign(diff);
}
