import haxe.ds.Vector;

abstract Vec4(Vector<Float>) {
	public function new() {
		this = new Vector(4);
	}

	@:arrayAccess
	public inline function get(k: Int) {
		return this[k];
	}

	@:arrayAccess
	public inline function set(k: Int, v: Float) {
		this[k] = v;
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
		this.equation = new Vec4();
		this.equation[0] = b[0];
		this.equation[1] = b[1];
		this.equation[2] = b[2];
		this.equation[3] = -(b[0] * a[0] + b[1] * a[1] + b[2] * a[2]);
	}

	static function from_triangle(a: Vec3, b: Vec3, c: Vec3) {
		var ba = b - a;
		var ca = c - a;

		var temp = Vec3.cross(ba, ca);
		temp.normalize();

		var plane = new Plane(a, temp);
		plane.equation[0] = temp[0];
		plane.equation[1] = temp[1];
		plane.equation[2] = temp[2];
		plane.equation[3] = -(temp[0] * a[0] + temp[1] * a[1] + temp[2] * a[2]);

		return plane;
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
