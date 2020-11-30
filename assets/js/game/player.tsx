import React from "react"

interface PlayerProps {
    player: TPlayer
}

export type TPlayer = {
    id: string
    anonymous: boolean
    name: string
    rank: number
}

export const Player = ({player}: PlayerProps) => {
    if (!player) return <></>

    return (
        <section>
            <span>{player.name}</span>
        </section>
    )
}
