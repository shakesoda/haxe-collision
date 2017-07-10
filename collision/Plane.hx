package collision;

import haxe.ds.Vector;

abstract Vec4(Vector<Float>) {
	public function new(a, b, c, d) {
		this = new Vector(4);
		this[0] = a;
		this[1] = b;
		this[2] = c;
		this[3] = d;
	}

	@:arrayAccess
	public inline function get(k: Int) {
		return this[k];
	}
}

@:publicFields
class Plane {
	var origin: Vec3;
	var normal: Vec3;
	var equation: Vec4;

	function new(a: Vec3, b: Vec3) {
		this.origin = a;
		this.normal = b;
		this.equation = new Vec4(
			b[0], b[1], b[2],
			-(b[0] * a[0] + b[1] * a[1] + b[2] * a[2])
		);
	}

	static function from_triangle(a: Vec3, b: Vec3, c: Vec3) {
		var ba = b - a;
		var ca = c - a;

		var temp = Vec3.cross(ba, ca);
		temp.normalize();

		return new Plane(a, temp);
	}

	function signed_distance(base_point: Vec3) {
		return Vec3.dot(base_point, this.normal) - Vec3.dot(this.normal, this.origin);
	}

	function is_front_facing(direction: Vec3): Bool {
		var f: Float = Vec3.dot(this.normal, direction);

		if (f <= 0.0) {
			return true;
		}

		return false;
	}
}
