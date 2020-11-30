import React from "react"
import styles from "./player.module.scss"

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
        <section className={styles.player}>
            <span className={styles.name}>{player.name}</span>
            <span className={styles.rank}>({player.rank})</span>
        </section>
    )
}
