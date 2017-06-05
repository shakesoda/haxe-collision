package;

@:publicFields
class CollisionPacket {
	// r3 space
	var r3_position: Vec3;
	var r3_velocity: Vec3;

	// ellipsoid space
	var e_radius: Vec3;
	var e_position: Vec3;
	var e_velocity: Vec3;
	var e_norm_velocity: Vec3;
	var e_base_point: Vec3;

	// hit information
	var found_collision: Bool;
	var nearest_distance: Float;
	var intersect_point: Vec3;

	// iteration depth
	var depth: Int;

	inline function new() {
		this.r3_position = new Vec3(0.0, 0.0, 0.0);
		this.r3_velocity = new Vec3(0.0, 0.0, 0.0);
		this.e_radius = new Vec3(1.0, 1.0, 1.0);
		this.e_position = new Vec3(0.0, 0.0, 0.0);
		this.e_velocity = new Vec3(0.0, 0.0, 0.0);
		this.e_norm_velocity = new Vec3(0.0, 0.0, 0.0);
		this.e_base_point = new Vec3(0.0, 0.0, 0.0);
		this.found_collision = false;
		this.nearest_distance = 0.0;
		this.intersect_point = new Vec3(0.0, 0.0, 0.0);
		this.depth = 0;
	}

	static function from_entity(position: Vec3, velocity: Vec3, radius: Vec3) {
		var packet = new CollisionPacket();
		packet.r3_position = position;
		packet.r3_velocity = velocity;

		packet.e_radius = radius;
		packet.e_position = packet.r3_position / packet.e_radius;
		packet.e_velocity = packet.r3_velocity / packet.e_radius;
		return packet;
	}
}
