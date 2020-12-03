import {Channel} from "phoenix"
import React from "react"

interface MoveProps {
    channel: Channel
    moves: []
    active: boolean
}

export const Move = ({channel, moves, active}: MoveProps) => (
    <button type="button"
            className="button"
            onClick={() => channel.push("move", {moves: moves})}
            disabled={!active}
    >
        End tour
    </button>
)
