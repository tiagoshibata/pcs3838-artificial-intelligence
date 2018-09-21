import heapq


class State:
    def __init__(self, state, cost, parent):
        self.state = state
        self.cost = cost
        self.parent = parent

    def __lt__(self, other):
        return self.cost < other.cost


def bfs(state, sucessor_f, final_test_f):
    visited_states = {state}
    heap = [State(state, 0, None)]
    while heap:
        next_expansion = heapq.heappop(heap)
        print('State {} with cost {} and parent {}'.format(
            next_expansion.state,
            next_expansion.cost,
            next_expansion.parent and next_expansion.parent.state))
        if final_test_f(next_expansion.state):
            return next_expansion
        next_states = sucessor_f(next_expansion.state)
        for state in next_states:
            if state not in visited_states:
                heapq.heappush(heap, State(state, next_expansion.cost + 1, next_expansion))
                visited_states.add(state)


def sucessor_f(state):
    boat_move = (not state[0], *state[1:])  # move boat to opposite margin
    successors = []
    for i, margin in enumerate(state):
        new_state = list(boat_move)
        new_state[i] = not new_state[i]
        new_state[0] = not state[0]
        if ((new_state[0] == new_state[1] or new_state[1] != new_state[2]) and
            (new_state[0] == new_state[2] or new_state[2] != new_state[3])):
            successors.append(tuple(new_state))
    return successors

# State: booleans representing whether the boat, wolf, sheep and cabbage are on the right margin
solution = bfs((False, False, False, False), sucessor_f, all)
print('Solution:')
while solution:
    print(solution.cost, solution.state)
    solution = solution.parent
