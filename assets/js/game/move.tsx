import {Channel} from "phoenix"
import React, {useContext} from "react"
import {MoveContext} from "./moveContext"

interface MoveProps {
    channel: Channel
    active: boolean
}

export const Move = ({channel, active}: MoveProps) => {
    const [ctx, dispatch] = useContext(MoveContext)

    const endRound = () => {
        channel.push("end_round", {moves: ctx.moves})
        dispatch({type: "roundEnd"})
    }

    return (
        <button type="button" className="button" onClick={endRound} disabled={!active}>
            End round
        </button>
    )
}
