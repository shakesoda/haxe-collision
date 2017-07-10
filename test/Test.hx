import collision.Response;
import collision.CollisionPacket;
import collision.Vec3;

class Test {
	static function get_triangles(min: Vec3, max: Vec3) {
		return [];
	}

	static function main() {
		var position = new Vec3(0, 0, 0);
		var velocity = new Vec3(0, 0, 0);
		var radius = new Vec3(0.5, 0.5, 1.0);
		var packet = new CollisionPacket(position, velocity, radius);

		var response = new Response(get_triangles);
		response.update(packet);

		position = packet.r3_position;
		velocity = packet.r3_velocity;
	}
}
