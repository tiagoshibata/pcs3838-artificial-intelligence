import heapq


class State:
    def __init__(self, state, parent):
        self.state = state
        self.parent = parent

state = [False, False, False, False]


def bfs(state, sucessor_f, final_test_f):
    visited_states = (state,)
    queue = deque((State(state, None)))
    while queue:
        next_expansion = queue.popleft()
        if final_test_f(next_expansion):
            return next_expansion
        next_states = sucessor_f(next_expansion)
        for state in next_states:
            if state not in visited_states:
                queue.append(State(state, next_expansion))
