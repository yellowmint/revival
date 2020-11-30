import React, {useState} from "react"
import {Board} from "./board"
import {useConnectionLogic} from "./useConnectionLogic"
import {Join} from "./join"
import {Player} from "./player"

export const Game = () => {
    const {game, channel} = useConnectionLogic()
    const [playerId, setPlayerId] = useState("")

    if (!game || !channel) return <div>Loading</div>

    let reversed = false
    if (playerId && game.players[0].id === playerId) {
        [game.players[0], game.players[1]] = [game.players[1], game.players[0]]
        reversed = true
    }

    return (
        <article>
            <Join channel={channel}
                  playersCount={game.players.length}
                  playerId={playerId}
                  setPlayerId={setPlayerId}/>

            <Player player={game.players[0]}/>
            <Board board={game.board} reversed={reversed}/>
            <Player player={game.players[1]}/>
        </article>
    )
}
