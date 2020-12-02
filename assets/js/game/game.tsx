import React from "react"
import {Board} from "./board"
import {TGame, useConnectionLogic} from "./useConnectionLogic"
import {Join} from "./join"
import {Player} from "./player"
import {Timer} from "./timer"
import {Round} from "./round"

export const Game = () => {
    const {game, playerId, channel} = useConnectionLogic()

    if (!game || !playerId || !channel) return <div>Loading</div>

    const {playerIdx, reversed} = determinePlayer(game, playerId)

    return (
        <article>
            <Join channel={channel}
                  players={game.players}
                  playerIdx={playerIdx}/>

            <Round round={game.round}/>
            <Timer startedAt={game.started_at} nextMoveDeadline={game.next_move_deadline} roundTime={game.round_time}/>

            <Player player={game.players[0]} nextMove={game.next_move}/>
            <Board board={game.board} reversed={reversed}/>
            <Player player={game.players[1]} nextMove={game.next_move}/>
        </article>
    )
}

function determinePlayer(game: TGame, playerId: string) {
    if (game.players[1]?.id === playerId) {
        return {playerIdx: 1, reversed: false}
    }

    if (game.players[0]?.id === playerId) {
        [game.players[0], game.players[1]] = [game.players[1], game.players[0]]
        return {playerIdx: 0, reversed: true}
    }

    return {playerIdx: null, reversed: false}
}
