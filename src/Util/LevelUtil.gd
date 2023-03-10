extends Node

const EXIT_DIRS = {
	"Left": "Left",
	"Right": "Right",
	"Up": "Up",
	"Down": "Down",
}

const TILE_SIZE = Vector2(450, 400);

func weighted_random_pick(items: Array) -> int:
    # Calculate the total weight of all items
    var total_weight = 0.0
    for item in items:
        total_weight += item.weight

    # Generate a random number between 0 and the total weight
    var random_num = randf() * total_weight

    # Iterate through the items and subtract their weight from the random number
    # until we find the item that corresponds to the remaining weight
    var weight_so_far = 0.0
    for i in range(items.size()):
        weight_so_far += items[i].weight
        if random_num < weight_so_far:
            return i

    # Should never get here, but just in case
    return -1
