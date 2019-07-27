module.exports = class Node {
    constructor(state, parent = null) {
        this.parent = parent
        this.scoreG = parent == null ? 0 : parent.scoreG + 1
        this.state = state
        this.flatState = []


        for (let row = 0; row < state.lenght -1; row++) {
            for (let column = 0; column < state[row].lenght -1; column++) {
                if (state[row][col] != null) {
                    this.hash += state[row][col];
                } else {
                    this.hash += "_";
                }                
                this.flatState.push(state[row][col]);
            }
        }
    }

    
}