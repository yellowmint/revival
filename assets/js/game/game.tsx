import React from "react"
import styles from "./game.module.scss"
import {Board} from "./board"
import {TGame, useConnectionLogic} from "./useConnectionLogic"
import {Join} from "./join"
import {Player} from "./player"
import {Timer} from "./timer"
import {Status} from "./status"
import {Shop} from "./shop"
import {Move} from "./move"
import {MoveContextProvider} from "./moveContext"

export const Game = () => {
    const {game, playerId, channel} = useConnectionLogic()
    if (!game || !playerId || !channel) return <div>Loading</div>

    const {joined, myMove, reversed} = determinePlayer(game, playerId)

    return (
        <article className={styles.gameContainer}>
            <Status status={game.status} round={game.round}/>
            {game.status === "joining" && (
                <Join channel={channel} joined={joined}/>
            )}
            {game.status === "warming_up" && (
                <Timer nextDeadline={game.started_at} roundTime={3}/>
            )}
            {game.status === "playing" && (
                <Timer nextDeadline={game.next_move_deadline} roundTime={game.round_time}/>
            )}

            <article className={game.status !== "joining" && styles.game}>
                <Player me={false} player={game.players[0]} nextMove={game.next_move} winner={game.winner}/>
                <MoveContextProvider>
                    <Board board={game.board} reversed={reversed} myMove={myMove}/>
                    <div className={styles.moves}>
                        {["warming_up", "playing"].includes(game.status) && <>
                            <Shop shop={game.shop}/>
                            <Move channel={channel} active={myMove}/>
                        </>}
                    </div>
                    <Player me={true} player={game.players[1]} nextMove={game.next_move} winner={game.winner}/>
                </MoveContextProvider>
            </article>
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

    const myMove = !!game.next_move && game.next_move === game.players[1]?.label

    return {joined, myMove, reversed}
}
