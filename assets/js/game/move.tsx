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
            onClick={() => channel.push("end_round", {moves: moves})}
            disabled={!active}
    >
        End round
    </button>
)
