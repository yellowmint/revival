import React from "react"
import {Board} from "./board"
import {useConnectionLogic} from "./useConnectionLogic"

export const Game = () => {
    const {game, channel} = useConnectionLogic()

    if (!game) return <div>Loading</div>

    return (
        <section>
            <Board board={game.board}/>
        </section>
    )
}
