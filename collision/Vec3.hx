package collision;

import haxe.ds.Vector;

abstract Vec3(Vector<Float>) {
	public function new(x: Float = 0, y: Float = 0, z: Float = 0) {
		this = new Vector<Float>(3);

		this[0] = x;
		this[1] = y;
		this[2] = z;
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

	@:op(A * B)
	public inline function scale(b: Float) {
		return new Vec3(this[0] * b, this[1] * b, this[2] * b);
	}

	public inline function length() {
		return Math.sqrt(this[0] * this[0] + this[1] * this[1] + this[2] * this[2]);
	}

	public inline function lengthsq() {
		return this[0] * this[0] + this[1] * this[1] + this[2] * this[2];
	}

	public inline function normalize() {
		var l = this[0] * this[0] + this[1] * this[1] + this[2] * this[2];
		if (l == 0) {
			return;
		}
		l = Math.sqrt(l);
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

	public static inline function dot(a: Vec3, b: Vec3) {
		return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
	}

	public function copy() {
		return new Vec3(this[0], this[1], this[2]);
	}
}
