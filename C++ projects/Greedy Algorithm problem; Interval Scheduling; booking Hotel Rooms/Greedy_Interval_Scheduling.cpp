#include <algorithm>
#include <assert.h>
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include <string>
#include <time.h>
#include <vector>

using namespace std;

void printRequests(vector<pair<int, int>> &roomReqs);
void printBookings(int nRooms, vector<pair<int, int>> bookings[]);

void generateIntervals(int n, vector<pair<int, int>> &intervals);
bool validateSchedule(int nRooms, vector<pair<int, int>> &intervals,
                      vector<pair<int, int>> bookings[]);
bool compareendtime(const pair<int, int> &x, const pair<int, int> &y) {
  return (x.second < y.second);
}

void scheduleRooms(int nRooms, vector<pair<int, int>> &roomReqs,
                   vector<pair<int, int>> schedule[]) {
  // To present values of roomReqs:
  vector<pair<int, int>> roomReqs1;
  for (int i = 0; i < roomReqs.size(); i++)
    roomReqs1.push_back(roomReqs[i]);
  // Before entering the for loop below, it'll be a good idea to sort roomReqs
  // according to end time
  sort(roomReqs.begin(), roomReqs.end(), compareendtime);

  for (int r = 1; r <= nRooms; r++) {
    if (roomReqs.size() <= 0)
      break;
    //  populate schedule[r] with 1st pair of roomReqs, then delete that pair
    //  from roomReqs
    schedule[r].push_back(roomReqs[0]);
    roomReqs.erase(roomReqs.begin());
    // traverse thru remaining roomReqs and where schedule_elem.2nd <=
    // roomReqs_elem.1st, transfer elem to schedule
    for (auto ptr = roomReqs.begin(); ptr != roomReqs.end(); ptr) {
      if (schedule[r].back().second <= ptr->first) {
        schedule[r].push_back(make_pair(ptr->first, ptr->second));
        ptr = roomReqs.erase(ptr);
      } else {
        ++ptr;
      }
    }
  }
  // Whatever is left behind in roomReqs that couldnt be accomodated in the
  // limited num of rooms, is placed in schedule[0]
  for (int i = 0; i < roomReqs.size(); i++)
    schedule[0].push_back(roomReqs[i]);

  // restore values in roomReqs:
  roomReqs.clear();
  for (int i = 0; i < roomReqs1.size(); i++)
    roomReqs.push_back(roomReqs1[i]);
}

int main() {
  char name[] = "Avijit Singh Jhyont; Testing provided curtasy of Ryerson Uni. Algorithms Professor Alex Ufkes.";
  srand((int)time(NULL));
  printf("\nCCPS616 - Greedy Algorithm Interval Scheduling - %s\n\n", name);

  /*****************************************************************/
  /* First, test algorithm on simple example from lab description  */
  /* You should create your own additional examples here!          */
  /*****************************************************************/
  {
    // 5 requests: [(1, 2), (3, 6), (5, 8), (6, 7), (6, 8)]
    vector<pair<int, int>> requests;
    requests.push_back(pair<int, int>(1, 2));
    requests.push_back(pair<int, int>(3, 6));
    requests.push_back(pair<int, int>(5, 8));
    requests.push_back(pair<int, int>(6, 7));
    requests.push_back(pair<int, int>(6, 8));

    // Allocate array of vectors for three rooms.
    // nRooms+1 to account for bookings that can't be accommodated
    vector<pair<int, int>> three_rooms[4];
    vector<pair<int, int>> two_rooms[3];

    /** Call your scheduleRooms() function here **/
    scheduleRooms(3, requests, three_rooms);
    scheduleRooms(2, requests, two_rooms);
    /*********************************************/

    // Compare your results (printed below) with the optimal results
    // given in the lab description. No asserts or anything this time,
    // just verify your small-scale tests manually.
    cout << "Room request intervals:" << endl;
    printRequests(requests);
    cout << endl << "Scheduling with three rooms:" << endl;
    printBookings(3, three_rooms);
    cout << endl << "Scheduling with two rooms:" << endl;
    printBookings(2, two_rooms);
    cout << endl;
  }

  /*****************************************************************/
  /* Next, test algorithm on increasingly large random samples     */
  /*****************************************************************/
  {
    int numIntervals[] = {16,   32,   64,   128,   256,   512,  1024,
                          2048, 4096, 8192, 16384, 32768, 65536};
    for (int n : numIntervals) {
      vector<pair<int, int>> reqs;
      generateIntervals(n, reqs);

      // sqrt(n) seems like a reasonable number of rooms for n total bookings...
      int nRooms = (int)sqrt(n);
      vector<pair<int, int>> *n_rooms = new vector<pair<int, int>>[nRooms + 1];

      cout << "Testing " << n << " intervals... ";

      /** Call your scheduleRooms() function here **/
      scheduleRooms(nRooms, reqs, n_rooms);
      /*********************************************/

      // I will uncomment this assert when I test your code. You should too!
      assert(validateSchedule(nRooms, reqs, n_rooms));

      cout << "Passed!" << endl;

      delete[] n_rooms;
    }
  }

  printf("\n");
}

void printRequests(vector<pair<int, int>> &roomReqs) {
  cout << "[ ";
  for (pair<int, int> p : roomReqs)
    cout << "(" << p.first << ", " << p.second << ") ";
  cout << "]" << endl;
}

void printBookings(int nRooms, vector<pair<int, int>> bookings[]) {
  for (int i = 1; i < nRooms + 1; i++) {
    cout << "Room #" << i << ": [ ";
    for (pair<int, int> p : bookings[i])
      cout << "(" << p.first << ", " << p.second << ") ";
    cout << "]" << endl;
  }
  cout << "No room: [ ";
  for (pair<int, int> p : bookings[0])
    cout << "(" << p.first << ", " << p.second << ") ";
  cout << "]" << endl;
}

// Function for generating random vectors of intervals. This function
// is very primitive, feel free to tweak it if you want to add more
// sophistication to the distribution of the intervals.
void generateIntervals(int n, vector<pair<int, int>> &intervals) {
  for (int i = 0; i < n; i++) {
    int start = rand() % (i + 1) * 2 + 1;
    int dif = rand() % (i + 1) + 1;
    intervals.push_back(pair<int, int>(start, start + dif));
  }
}

// Function for validating scheduling. Does not check for optimal solution,
// Just verifies that no bookings overlap. Checks for feasible solution!
bool validateSchedule(int nRooms, vector<pair<int, int>> &intervals,
                      vector<pair<int, int>> bookings[]) {
  for (int i = 1; i < nRooms + 1; i++) {
    // Check that intervals in each room don't overlap
    for (int j = 1; j < (int)bookings[i].size(); j++)
      if (bookings[i][j - 1].second > bookings[i][j].first)
        return false;
  }

  int count = 0;
  for (int i = 0; i < nRooms + 1; i++) {
    // Check that interval in schedule exists in vector of intervals
    for (pair<int, int> p : bookings[i])
      if (std::find(intervals.begin(), intervals.end(), p) == intervals.end())
        return false;

    // Ensure all intervals are present in schedule (includes no room)
    count += bookings[i].size();
  }

  if (count != intervals.size())
    return false;

  return true;
}