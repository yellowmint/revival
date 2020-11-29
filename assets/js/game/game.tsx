import React from "react"
import {Board} from "./board"
import {useConnectionLogic} from "./useConnectionLogic"
import {Join} from "./join"

export const Game = () => {
    const {game, channel} = useConnectionLogic()

    if (!game || !channel) return <div>Loading</div>

    return (
        <section>
            <Join channel={channel} players={game.players}/>
            <Board board={game.board}/>
        </section>
    )
}
