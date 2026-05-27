#include <iostream>
#include <vector>
#include <queue>

using namespace std;

// Structure to store coordinates
struct Node {
    int x, y;
};

// Grid size
const int ROWS = 10;
const int COLS = 10;

// 0 = free path
// 1 = obstacle/wall
int grid[ROWS][COLS] = {
    {0,0,0,0,1,0,0,0,0,0},
    {1,1,0,0,1,0,1,1,1,0},
    {0,0,0,1,0,0,0,0,1,0},
    {0,1,0,1,0,1,1,0,1,0},
    {0,1,0,0,0,0,1,0,0,0},
    {0,1,1,1,1,0,1,1,1,0},
    {0,0,0,0,1,0,0,0,1,0},
    {1,1,1,0,1,1,1,0,1,0},
    {0,0,0,0,0,0,1,0,0,0},
    {0,1,1,1,1,0,0,0,1,0}
};

// Keeps track of visited cells
bool visited[ROWS][COLS] = {false};

// Movement directions
// Up, Down, Left, Right
int dx[4] = {-1, 1, 0, 0};
int dy[4] = {0, 0, -1, 1};

// Check whether next move is valid
bool isValid(int x, int y) {

    return x >= 0 &&
           y >= 0 &&
           x < ROWS &&
           y < COLS &&
           grid[x][y] == 0 &&
           !visited[x][y];
}

// Breadth First Search
void bfs(Node start, Node goal) {

    queue<Node> q;

    // Start node pushed into queue
    q.push(start);

    // Mark start as visited
    visited[start.x][start.y] = true;

    while (!q.empty()) {

        // Get front node
        Node current = q.front();
        q.pop();

        cout << "Robot visiting: ("
             << current.x
             << ", "
             << current.y
             << ")" << endl;

        // Goal reached
        if (current.x == goal.x &&
            current.y == goal.y) {

            cout << "\nGoal reached!" << endl;
            return;
        }

        // Explore 4 directions
        for (int i = 0; i < 4; i++) {

            int nx = current.x + dx[i];
            int ny = current.y + dy[i];

            // Check if move is possible
            if (isValid(nx, ny)) {

                visited[nx][ny] = true;

                q.push({nx, ny});
            }
        }
    }

    cout << "No path found!" << endl;
}

int main() {

    Node start = {0, 0};
    Node goal = {9, 9};

    bfs(start, goal);

}