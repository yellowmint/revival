import {useEffect, useState} from "react"
import {Channel, Socket} from "phoenix"
import {TBoard} from "./board"
import {useAuthToken} from "./useAuthToken"
import {TPlayer} from "./player"

export type TGame = {
    status: string
    board: TBoard
    players: Array<TPlayer>
    started_at: string
    next_move: string
    next_move_deadline: string
    round: number
    round_time: number
}

export const useConnectionLogic = () => {
    const [game, setGame] = useState<TGame>()
    const [playerId, setPlayerId] = useState("")
    const [channel, setChannel] = useState<Channel>()
    const {authToken} = useAuthToken()

    useEffect(() => {
        if (authToken === undefined) return

        const authParams = authToken ? {token: authToken} : {}
        const socket = new Socket('/socket', {params: authParams})
        socket.connect()

        const {pathname} = window.location
        const id = pathname.substring(pathname.lastIndexOf('/') + 1)

        const channelHandle = socket.channel("play:" + id)
        channelHandle.join()
            .receive("ok", ({play, player_id}: {play: TGame, player_id: string}) => {
                console.log("play load", play, player_id)
                setGame(play)
                setPlayerId(player_id)
            })
            .receive("error", resp => console.log("Unable to join", resp))

        setChannel(channelHandle)
        return () => socket.disconnect()
    }, [authToken])

    useEffect(() => {
        if (!channel) return
        const ref = channel.on("play_update", (play: TGame) => {
            console.log("play update", play)
            setGame(play)
        })
        return () => channel.off("play_update", ref)
    }, [channel])

    return {game, playerId, channel}
}
