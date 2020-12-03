import React from "react"
import {Board} from "./board"
import {TGame, useConnectionLogic} from "./useConnectionLogic"
import {Join} from "./join"
import {Player} from "./player"
import {Timer} from "./timer"
import {Status} from "./status"
import {Shop} from "./shop"
import {Move} from "./move"

export const Game = () => {
    const {game, playerId, channel} = useConnectionLogic()
    if (!game || !playerId || !channel) return <div>Loading</div>

    const {joined, myMove, reversed} = determinePlayer(game, playerId)

    return (
        <article>
            <Status status={game.status} round={game.round}/>
            {game.status === "joining" && (
                <Join channel={channel} joined={joined}/>
            )}
            {["warming_up", "playing"].includes(game.status) && (
                <Timer nextDeadline={game.next_move_deadline || game.started_at}
                       roundTime={game.round_time}/>
            )}

            <Player player={game.players[0]} nextMove={game.next_move} winner={game.winner}/>
            <Board board={game.board} reversed={reversed}/>
            {["warming_up", "playing", "finished"].includes(game.status) && (
                <Shop shop={game.shop}/>
            )}
            {game.status === "playing" && (
                <Move channel={channel} moves={[]} active={myMove}/>
            )}
            <Player player={game.players[1]} nextMove={game.next_move} winner={game.winner}/>
        </article>
    )
}

function determinePlayer(game: TGame, playerId: string) {
    let joined = false
    let reversed = false

    if (game.players.findIndex(x => x.id === playerId) !== -1) {
        joined = true
    }

    if (game.players[0]?.id === playerId) {
        [game.players[0], game.players[1]] = [game.players[1], game.players[0]]
        reversed = true
    }

    const myMove = game.players[1]?.label === game.next_move

    return {joined, myMove, reversed}
}
