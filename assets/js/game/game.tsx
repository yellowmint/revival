import React, {useEffect, useState} from "react"
import {Channel, Socket} from "phoenix"
import {Board, TBoard} from "./board"

type Game = {
    board: TBoard
}

export const Game = () => {
    const [game, setGame] = useState<Game>()
    const [channel, setChannel] = useState<Channel>()

    useEffect(() => {
        const tokenTag = document.querySelector('meta[name="auth-token"]') as HTMLMetaElement
        const authParams = tokenTag ? {token: tokenTag.content} : {}

        const socket = new Socket('/socket', {params: authParams})
        socket.connect()

        const {pathname} = window.location
        const id = pathname.substring(pathname.lastIndexOf('/') + 1)

        const channelHandle = socket.channel("game:" + id)
        channelHandle.join()
            .receive("ok", resp => setGame(resp))
            .receive("error", resp => console.log("Unable to join", resp))

        setChannel(channelHandle)
        return () => socket.disconnect()
    }, [])

    if (!game) return <div>Loading</div>

    return (
        <section>
            <Board board={game.board}/>
        </section>
    )
}
