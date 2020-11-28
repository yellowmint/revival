import React, {useEffect, useState} from "react"
import {Socket} from "phoenix"
import {Board, TBoard} from "./board"

type Game = {
    board: TBoard
}

export const Game: React.FC = () => {
    const [game, setGame] = useState<Game | null>(null)

    useEffect(() => {
        const tokenTag = document.querySelector('meta[name="auth-token"]') as HTMLMetaElement
        const authParams = tokenTag ? {token: tokenTag.content} : {}

        const socket = new Socket('/socket', {params: authParams})
        socket.connect()

        const pathname = window.location.pathname
        const id = pathname.substring(pathname.lastIndexOf('/') + 1)

        const channel = socket.channel("game:" + id)
        channel.join()
            .receive("ok", resp => setGame(resp))
            .receive("error", resp => console.log("Unable to join", resp))

        return () => socket.disconnect()
    }, [])

    if (!game) return <div>Loading</div>

    return (
        <section>
            <Board board={game.board}/>
        </section>
    )
}

