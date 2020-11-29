import React, {useEffect} from "react"
import {Channel} from "phoenix"

interface JoinProps {
    channel: Channel
    players: Array<TPlayer>
}

export type TPlayer = {
    id: string
    anonymous: boolean
    name: string
    rank: number
}

export const Join = ({channel, players}: JoinProps) => {
    useEffect(() => {
        const ref = channel.on("joined", payload => {
            console.log("joined", payload)
        })

        return () => channel.off("joined", ref)
    })

    const join = () => channel.push("join_game", {name: 'anonymous'})

    if (players.length >= 2) return <></>

    return (
        <section>
            <button className="button" onClick={join}>Join</button>
        </section>
    )
}
