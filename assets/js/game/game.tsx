import React, { useEffect, useState } from "react"
import { Socket } from "phoenix"
import {Board, TBoard} from "./board"

type Game = {
    board: TBoard
}

export const Game: React.FC = () => {
    const [game, setGame] = useState<Game | null>(null)

    useEffect(() => {
        const socket = new Socket('/socket', { params: { token: "your auth token" } })
        socket.connect()

        const pathname = window.location.pathname
        const id = pathname.substring(pathname.lastIndexOf('/') + 1)

        const channel = socket.channel("game:" + id)
        channel.join()
            .receive("ok", resp => setGame(resp) )
            .receive("error", resp => { console.log("Unable to join", resp) })
    }, [])

    if (!game) return <div>Loading</div>

    return (
        <section>
            <Board board={game.board} />
        </section>
    )
}

