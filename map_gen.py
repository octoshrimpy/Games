"""map_gen.py

A function to generate a dungeon map.
"""

from random import randrange, choice
from math import sqrt

MIN_ROOMS = 4
MAX_ROOMS = 8

MIN_WIDTH = MIN_HEIGHT = 3
MAX_WIDTH = MAX_HEIGHT = 5

class MapGenerator:
    """A procedural map generator to create dungeon maps."""

    def __init__(self, map_width, map_height):
        self.map_width = map_width
        self.map_height = map_height

    def generate_blank_map(self):
        """Generates a solid map of walls '#' with given dimensions.

        returns the solid map.
        """

        # initialise the blank map
        blank_map = []

        # loop through and generate the solid, blank map
        for i in range(self.map_height):
            blank_map.append([])
            for j in range(self.map_width):
                blank_map[i].append("#")

        return blank_map


    def generate_room(self, dungeon_map):
        """Generate a randomly sized room with a random position.

        returns a tuple of (x, y, width, height)
        """

        # define the map dimensions locally
        self.map_width = len(dungeon_map[0])
        self.map_height = len(dungeon_map)

        # generate the room's origin, width and height
        origin = (randrange(self.map_width), randrange(self.map_height))
        width = randrange(MIN_WIDTH, MAX_WIDTH)
        height = randrange(MIN_HEIGHT, MAX_HEIGHT)

        # check whether the room is contained within the map.

        if origin[0] == 0 or origin[1] == 0:
            return False

        elif width + origin[0] >= self.map_width or height + origin[1] >= self.map_height:
            return False

        room = (origin[0], origin[1], width, height)
        return room

    def collides(self, room1, room2):
        """Checks whether there is overlap between two rectangular rooms."""

        # define all coordinate points for each room
        room1_x1 = room1[0]
        room1_x2 = room1[0] + room1[2]
        room1_y1 = room1[1]
        room1_y2 = room1[1] + room1[3]

        room2_x1 = room2[0]
        room2_x2 = room2[0] + room2[2]
        room2_y1 = room2[1]
        room2_y2 = room2[1] + room2[3]

        # check for an overlap between the four points of room2 with room1
        # room2 (x1,y1)
        if room1_x1 <= room2_x1 <= room1_x2 and room1_y1 <= room2_y1 <= room1_y2:
            return True
        # room2 (x1,y2)
        elif room1_x1 <= room2_x1 <= room1_x2 and room1_y1 <= room2_y2 <= room1_y2:
            return True
        # room2 (x2,y1)
        elif room1_x1 <= room2_x2 <= room1_x2 and room1_y1 <= room2_y1 <= room1_y2:
            return True
        # room2 (x2, y2)
        elif room1_x1 <= room2_x2 <= room1_x2 and room1_y1 <= room2_y2 <= room1_y2:
            return True

        # check for an overlap between the four points of room1 with room2
        if room2_x1 <= room1_x1 <= room2_x2 and room2_y1 <= room1_y1 <= room2_y2:
            return True
        # room2 (x1,y2)
        elif room2_x1 <= room1_x1 <= room2_x2 and room2_y1 <= room1_y2 <= room2_y2:
            return True
        # room2 (x2,y1)
        elif room2_x1 <= room1_x2 <= room2_x2 and room2_y1 <= room1_y1 <= room2_y2:
            return True
        # room2 (x2, y2)
        elif room2_x1 <= room1_x2 <= room2_x2 and room2_y1 <= room1_y2 <= room2_y2:
            return True

        return False

    def place_rooms(self, blank_map):
        """Generate and place the rooms. Overlapping rooms are not allowed."""

        # generate the number of rooms
        num_rooms = randrange(MIN_ROOMS, MAX_ROOMS)

        # initialise the empty rooms list
        rooms = []

        # add rooms to the list with no overlapping rooms.
        while num_rooms > 0:
            # generate a new room
            new_room = self.generate_room(blank_map)

            # initialise the collision variable
            collision = False

            # check if the new room has successfully generated.
            if not new_room:
                continue

            # if there are no rooms, add it to the list of rooms.
            if not len(rooms):
                rooms.append(new_room)
                continue

            # loop through the rooms and check the new room doesn't collide with
            # any of the existing rooms. If it does, it sets the collision variable
            # to true.
            for room in rooms:
                if self.collides(room, new_room):
                    collision = True

            # if a room has collided, go back to the beginning of the main loop
            if collision:
                continue

            # add the new to the list of rooms and decrease the number of rooms.
            rooms.append(new_room)
            num_rooms -= 1

        # loop through the list of rooms and place them in the blank map.
        for room in rooms:
            x = room[0]
            y = room[1]
            width = room[2]
            height = room[3]
            for i in range(width):
                for j in range(height):
                    blank_map[y+j][x+i] = '.'

        dungeon_map = blank_map

        return (dungeon_map, rooms)


    def get_distance(self, room1, room2):
        """Determine the euclidean distance between two points."""

        return sqrt((room1[0]-room2[0])**2 + (room1[1]-room2[1])**2)

    def get_path(self, start, end):
        """A simple Manhattan distance pathfinder."""

        # initialise the path and current_pos variables
        current_pos = start
        path = [start]


        # loop through to determine the path
        while current_pos != end:

            # move along the x-axis towards the target.
            if current_pos[0] < end[0]:
                new_x = current_pos[0] + 1
                current_pos = (new_x, current_pos[1])
                path.append(current_pos)
                continue
            elif current_pos[0] > end[0]:
                new_x = current_pos[0] - 1
                current_pos = (new_x, current_pos[1])
                path.append(current_pos)
                continue

            # move along the y-axis toward the target having moved along the x-axis.
            if current_pos[1] < end[1]:
                new_y = current_pos[1] + 1
                current_pos = (current_pos[0], new_y)
                path.append(current_pos)
                continue
            elif current_pos[1] > end[1]:
                new_y = current_pos[1] - 1
                current_pos = (current_pos[0], new_y)
                path.append(current_pos)
                continue

            # check if the current position in the end position and add to the path.
            if current_pos == end:
                path.append(end)

        return path

    def place_corridors(self, dungeon_map, rooms):
        """Places corridors between rooms."""

        rooms_copy = rooms
        exited_rooms = []

        for i, room in enumerate(rooms):
            # pop and append the room to shift the rooms list left by one. Add the
            # current room to the exited_rooms list.
            current_room = rooms.pop(0)
            rooms.append(current_room)
            exited_rooms.append(current_room)

            # determine the complement of between all rooms and the rooms
            # already exited.
            rooms_left = [room_ for room_ in rooms if room_ not in exited_rooms]

            # sort the rooms_left in order of lowest euclidean distance.
            rooms_left = sorted(rooms_left,
                                key=lambda room_: self.get_distance(room_, current_room))

            # check whether there are rooms left and define the target room.
            if len(rooms_left) == 0:
                break
            target_room = rooms_left.pop(0)

            # get random start point in current_room and end point in target_room
            x1 = current_room[0] + randrange(current_room[2])
            y1 = current_room[1] + randrange(current_room[3])
            start = (x1, y1)

            x2 = target_room[0] + randrange(target_room[2])
            y2 = target_room[1] + randrange(target_room[3])
            end = (x2 ,y2)

            # get path between start and end points
            path = self.get_path(start, end)

            # loop through the path and set the coordinates to '.'
            for pos in path:
                dungeon_map[pos[1]][pos[0]] = '.'

        return dungeon_map

    def create(self):
        world_map = self.generate_blank_map()
        world_map_info = self.place_rooms(world_map)
        final_map = self.place_corridors(world_map_info[0], world_map_info[1])
        print(str(x) for x in (str(y) for y in final_map))

mg = MapGenerator(20,20)
mg.create()
