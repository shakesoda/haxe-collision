package collision;

@:publicFields
class CollisionPacket {
	static var LARGE_NUMBER: Float = 1e20;

	/** Position in world space. Assumes Z-up. **/
	var r3_position = new Vec3(0.0, 0.0, 0.0);

	/** Velocity in world space. Assumes Z-up. **/
	var r3_velocity = new Vec3(0.0, 0.0, 0.0);

	/** Ellipsoid radius in world units. Assumes Z-up. **/
	var e_radius        = new Vec3(1.0, 1.0, 1.0);

	/** Position in ellipsoid-space. Used internally. **/
	var e_position      = new Vec3(0.0, 0.0, 0.0);
	/** Velocity in ellipsoid-space. Used internally. **/
	var e_velocity      = new Vec3(0.0, 0.0, 0.0);

	/** Found a collision. **/
	var found_collision = false;

	/** Distance to nearest collision if `found_collision` is set, otherwise `1e20` **/
	var nearest_distance = LARGE_NUMBER;

	/** Iteration depth. Useful for debugging slow collisions. **/
	var depth: Int = 0;

	// internal stuff
	var e_norm_velocity = new Vec3(0.0, 0.0, 0.0);
	var e_base_point    = new Vec3(0.0, 0.0, 0.0);
	var intersect_point = new Vec3(0.0, 0.0, 0.0);

	/** `true` if packet is on something reasonable to call the ground.
	 *
	 * _in practice, you probably want a sensor in your game code instead._ **/
	var grounded: Bool = false;

	/** Recalculate e-space from r3 vectors. Call this if you updated `r3_*` **/
	inline function to_e() {
		this.e_position = this.r3_position / this.e_radius;
		this.e_velocity = this.r3_velocity / this.e_radius;
	}

	/** Recalculate e-space from r3 vectors. Call this if you updated `e_*` **/
	inline function to_r3() {
		this.r3_position = this.e_position * this.e_radius;
		this.r3_velocity = this.e_velocity * this.e_radius;
	}

	inline function new(?position: Vec3, ?velocity: Vec3, ?radius: Vec3) {
		if (position != null) { this.r3_position = position; }
		if (velocity != null) { this.r3_velocity = velocity; }
		if (radius   != null) { this.e_radius    = radius; }
		this.to_e();
	}
}
