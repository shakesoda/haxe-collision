package collision;

import haxe.ds.Vector;

abstract Vec3(Vector<Float>) {
	public function new(x: Float = 0, y: Float = 0, z: Float = 0) {
		this = new Vector<Float>(3);

		this[0] = x;
		this[1] = y;
		this[2] = z;
	}

	public static function unit_x() {
		return new Vec3(1, 0, 0);
	}

	public static function unit_y() {
		return new Vec3(0, 1, 0);
	}

	public static function unit_z() {
		return new Vec3(0, 0, 1);
	}

	@:arrayAccess
	public inline function get(k: Int) {
		return this[k];
	}

	@:arrayAccess
	public inline function set(k: Int, v: Float) {
		this[k] = v;
	}

	@:op(A + B)
	public inline function add(b: Vec3) {
		return new Vec3(this[0] + b[0], this[1] + b[1], this[2] + b[2]);
	}

	@:op(A - B)
	public inline function sub(b: Vec3) {
		return new Vec3(this[0] - b[0], this[1] - b[1], this[2] - b[2]);
	}

	@:op(A / B)
	public inline function div(b: Vec3) {
		return new Vec3(this[0] / b[0], this[1] / b[1], this[2] / b[2]);
	}

	@:op(A * B)
	public inline function mul(b: Vec3) {
		return new Vec3(this[0] * b[0], this[1] * b[1], this[2] * b[2]);
	}

	@:op(A / B)
	public inline function fdiv(b: Float) {
		return new Vec3(this[0] / b, this[1] / b, this[2] / b);
	}

	@:op(A * B)
	public inline function scale(b: Float) {
		return new Vec3(this[0] * b, this[1] * b, this[2] * b);
	}

	@:op(-A)
	public inline function neg() {
		return scale(-1);
	}

	public inline function length() {
		return Math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
	}

	public inline function lengthsq() {
		return this[0] * this[0] + this[1] * this[1] + this[2] * this[2];
	}

	public inline function normalize() {
		var l = Math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
		if (l == 0) {
			return;
		}
		this[0] /= l;
		this[1] /= l;
		this[2] /= l;
	}

	public static inline function cross(a: Vec3, b: Vec3) {
		return new Vec3(
			a[1] * b[2] - a[2] * b[1],
			a[2] * b[0] - a[0] * b[2],
			a[0] * b[1] - a[1] * b[0]
		);
	}

	public static inline function distance(a: Vec3, b: Vec3) {
		var dx = a[0] - b[0];
		var dy = a[1] - b[1];
		var dz = a[2] - b[2];
		return Math.sqrt(dx * dx + dy * dy + dz * dz);
	}

	public inline function trim(max_len: Float) {
		var len = Math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
		if (len > max_len) {
			this[0] /= len;
			this[1] /= len;
			this[2] /= len;
			this[0] *= max_len;
			this[1] *= max_len;
			this[2] *= max_len;
		}
	}

	public static function min(a: Vec3, b: Vec3) {
		return new Vec3(
			Math.min(a[0], b[0]),
			Math.min(a[1], b[1]),
			Math.min(a[2], b[2])
		);
	}

	public static function max(a: Vec3, b: Vec3) {
		return new Vec3(
			Math.max(a[0], b[0]),
			Math.max(a[1], b[1]),
			Math.max(a[2], b[2])
		);
	}

	public static inline function dot(a: Vec3, b: Vec3) {
		return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
	}

	public function copy() {
		return new Vec3(this[0], this[1], this[2]);
	}

	public static inline function lerp(low: Vec3, high: Vec3, progress: Float): Vec3 {
		return ((high - low) + low) * progress;
	}

#if lua
	public function unpack() {
		return lua.Table.create([ this[0], this[1], this[2] ]);
	}
#end
}
