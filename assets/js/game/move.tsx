import {Channel} from "phoenix"
import React, {useContext} from "react"
import {MoveContext} from "./moveContext"

interface MoveProps {
    channel: Channel
    active: boolean
}

export const Move = ({channel, active}: MoveProps) => {
    const [ctx] = useContext(MoveContext)

    return (
        <button type="button"
                className="button"
                onClick={() => channel.push("end_round", {moves: ctx.moves})}
                disabled={!active}
        >
            End round
        </button>
    )
}
