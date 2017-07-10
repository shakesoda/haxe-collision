package collision;

abstract Triangle(Array<Vec3>) {
	public inline function new(v0: Vec3, v1: Vec3, v2: Vec3) {
		this = [ v0, v1, v2 ];
	}

	@:arrayAccess
	public inline function get(k: Int) {
		return this[k];
	}
}

typedef TriangleQueryFn = Vec3->Vec3->Array<Triangle>;

class Response {
	static var UNITS_PER_METER = 100.0;
	static var vmax: Float = 0;

	var get_triangles: TriangleQueryFn;

	function collide_with_world(packet: CollisionPacket, e_position: Vec3, e_velocity: Vec3, slide_threshold: Float) {
		var unit_scale:      Float = UNITS_PER_METER / 100.0;
		var very_close_dist: Float = 0.005 * unit_scale;

		if (packet.depth > 5) {
			return e_position;
		}

		// setup
		packet.e_velocity       = e_velocity;
		packet.e_norm_velocity = e_velocity.copy();
		packet.e_norm_velocity.normalize();
		packet.e_base_point     = e_position;

		packet.found_collision  = false;
		packet.nearest_distance = 1e20;

		// check for collision
		// NB: scale the octree query by velocity to make sure we still get the
		// triangles we need at high velocities. without this, long falls will
		// jam you into the floor. A bit (10%) of padding is added so I can
		// sleep at night.
		//
		// TODO: can this be cached? max velocity will never increase, so
		// it seems like it'd be safe to query the max size only once, before
		// hitting this function at all.
		var scale = Math.max(1.5, e_velocity.length()) * 1.1;

		var r3_position = e_position * packet.e_radius;
		var query_radius = packet.e_radius * scale;
		var min = r3_position - query_radius;
		var max = r3_position + query_radius;
		var tris = this.get_triangles(min, max);
		check_collision(packet, tris);

		// no collision
		if (!packet.found_collision) {
			return e_position + e_velocity;
		}

		// collision, now we have to actually do work...
		var dest_point     = e_position + e_velocity;
		var new_base_point = e_position;

		// only update if we are very close
		// or move very close
		if (packet.nearest_distance >= very_close_dist) {
			var v = e_velocity.copy();
			v.trim(packet.nearest_distance - very_close_dist);
			new_base_point = packet.e_base_point + v;
			v.normalize();
			packet.intersect_point -= v * very_close_dist;
		}

		// determine sliding plane
		var slide_plane_origin = packet.intersect_point.copy();
		var slide_plane_normal = new_base_point - packet.intersect_point;
		slide_plane_normal.normalize();

		var sliding_plane = new Plane(slide_plane_origin, slide_plane_normal);
		var slide_factor = sliding_plane.signed_distance(dest_point);

		// don't slide down with gravity on near-flat surfaces
		if (packet.intersect_point[2] <= e_position[2] && sliding_plane.normal[2] > slide_threshold && e_velocity[2] < 0.0) {
			return new_base_point;
		}

		var new_dest_point = dest_point - slide_plane_normal * slide_factor;

		// new velocity for next iteration
		var new_velocity = new_dest_point - packet.intersect_point;

		// dont recurse if velocity is tiny
		if (new_velocity.length() < very_close_dist) {
			return new_base_point;
		}

		packet.depth += 1;

		// down the rabbit hole we go
		return collide_with_world(packet, new_base_point, new_velocity, slide_threshold);
	}

	function check_collision(packet: CollisionPacket, tris: Array<Triangle>) {
		for (tri in tris) {
			Collision.check_triangle(
				packet,
				tri[0] / packet.e_radius,
				tri[1] / packet.e_radius,
				tri[2] / packet.e_radius
			);
		}
	}

	function collide_and_slide(packet: CollisionPacket, gravity: Vec3) {
		// convert to e-space
		var e_position = packet.r3_position / packet.e_radius;
		var e_velocity = packet.r3_velocity / packet.e_radius;
		var final_position = new Vec3();
		e_velocity[2] = Math.max(0.0, e_velocity[2]);

		var slide_threshold = 0.9;

		// do velocity iteration
		packet.depth = 0;
		final_position = collide_with_world(packet, e_position, e_velocity, slide_threshold);

		// convert back to r3 space
		packet.r3_position = final_position * packet.e_radius;
		packet.r3_velocity = gravity.copy();

		// convert velocity to e-space
		e_velocity = gravity / packet.e_radius;

		// do gravity iteration
		packet.depth = 0;
		final_position = collide_with_world(packet, final_position, e_velocity, slide_threshold);

		//var new_velocity = packet.r3_position - final_position * packet.e_radius;
		packet.r3_velocity = new Vec3();

		// finally, set entity position
		packet.r3_position = final_position * packet.e_radius;
	}

	public function new(fn: TriangleQueryFn) {
		this.get_triangles = fn;
	}

	public function update(packet: CollisionPacket) {
		var gravity = new Vec3(0, 0, Math.min(packet.r3_velocity[2], 0));
		collide_and_slide(packet, gravity);
	}
}
