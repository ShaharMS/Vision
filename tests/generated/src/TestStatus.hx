package;

import vision.exceptions.Unimplemented;


enum abstract TestStatus(String) {
    var Success;
    var Failure;
    var Skipped;
    var Unimplemented;

    overload extern public static inline function of(condition:Bool):TestStatus {
        return condition ? Success : Failure;
    }

    overload extern public static inline function of(item:Dynamic, equals:Dynamic):TestStatus {
        function deepEquals (lhs:Dynamic, rhs:Dynamic) {
            if (lhs is Array && rhs is Array) {
                var lhsIterator = lhs.iterator();
                var rhsIterator = rhs.iterator();
                while (lhsIterator.hasNext() && rhsIterator.hasNext()) {
                    if (!deepEquals(lhsIterator.next(), rhsIterator.next())) {
                        return false;
                    }
                }
                return !lhsIterator.hasNext() && !rhsIterator.hasNext();
            } else {
                return lhs == rhs;
            }
        }

        return deepEquals(item, equals) ? Success : Failure;
    }

    public static function multiple(...results:TestStatus) {
        var items = results.toArray();
        var result:TestStatus = items[0];
        for (i in 1...items.length) {
            result = switch (items[i]) {
                case Failure: Failure;
                case Unimplemented if (result != Failure): Unimplemented;
                case Success if (![Failure, Unimplemented].contains(result)): Success;
                case Skipped if (result == Success): Success;
                default: result;
            }
        }
        return result;
    }
}