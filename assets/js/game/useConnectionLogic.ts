import {useEffect, useState} from "react";
import {Channel, Socket} from "phoenix";
import {TBoard} from "./board";
import {TPlayer} from "./join"
import {useAuthToken} from "./useAuthToken"

type Game = {
    board: TBoard
    players: Array<TPlayer>
}

export const useConnectionLogic = () => {
    const [game, setGame] = useState<Game>()
    const [channel, setChannel] = useState<Channel>()
    const {authToken} = useAuthToken()

    useEffect(() => {
        if (authToken === undefined) return

        const authParams = authToken ? {token: authToken} : {}
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
    }, [authToken])

    useEffect(() => {
        if (!channel) return

        const ref = channel.on("game_update", resp => {
            console.log("game_update", resp)
            setGame(resp)
        })

        return () => channel.off("game_update", ref)
    }, [channel])

    return {game, channel}
}
