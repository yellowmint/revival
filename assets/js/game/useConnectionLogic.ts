import {useEffect, useState} from "react";
import {Channel, Socket} from "phoenix";
import {TBoard} from "./board";
import {TPlayer} from "./join"

type Game = {
    board: TBoard
    players: Array<TPlayer>
}

export const useConnectionLogic = () => {
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

    return {game, channel}
}
