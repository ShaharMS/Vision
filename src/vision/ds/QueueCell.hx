package vision.ds;

#if (flash || cpp) @:generic #end
class QueueCell<T> {
	public var previous:QueueCell<T>;

	public var value:T;

	public var next:QueueCell<T>;

	public function new(value:T, next:QueueCell<T>, previous:QueueCell<T>) {
		this.previous = previous;
		this.value = value;
		this.next = next;
	}

	@:to @:noCompletion public function getValue():T {
		return value;
	}
}