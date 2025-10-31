# File-System-Manager

File-System-Manager

This project is an Assembly language implementation of a minimal file system manager, created for the Computer Systems Architecture (ASC) laboratory assignment at the University of Bucharest, Faculty of Mathematics and Computer Science.

The repository contains solutions for the two main requirements of the assignment: managing storage in both one-dimensional and two-dimensional (matrix) space.

Project Components

The project is divided into two main components, corresponding to the files in the repository:

1. Unidimensional.s (One-Dimensional System)

This program manages a conceptual 1D storage device (like a single strip of memory) divided into blocks. It implements core file management operations by reading numeric commands from standard input.

Supported Operations:

ADD (1): Allocates the first available contiguous block of space for a new file.

GET (2): Returns the start and end block IDs for a given file.

DELETE (3): Frees the blocks occupied by a file, marking them as empty (ID 0).

DEFRAGMENTATION (4): Compacts the storage by moving all allocated blocks to the beginning of the memory, consolidating all free space at the end.

2. Bidimensional.s (Two-Dimensional System)

This program extends the file system logic to a 2D matrix of storage blocks. Files are stored contiguously along the rows of the matrix.

Supported Operations:

ADD (1): Finds the first available contiguous segment on a row that can fit the file.

GET (2): Returns the start (row, col) and end (row, col) coordinates for a given file.

DELETE (3): Frees the blocks occupied by a file.

DEFRAGMENTATION (4): Compacts the storage matrix by shifting all files as far "up" and "left" as possible, moving all empty blocks to the "bottom-right".
