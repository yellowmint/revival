import React from "react"
import styles from "./player.module.scss"

interface PlayerProps {
    player: TPlayer
    nextMove: string
    winner: string
}

export type TPlayer = {
    id: string
    name: string
    rank: number
    label: string
}

export const Player = ({player, nextMove, winner}: PlayerProps) => {
    if (!player) return <></>

    const isWinner = winner && player.label === winner

    return (
        <section className={`${styles.player} ${isWinner && styles.winner}`}>
            <div className={styles.playerDetails}>
                <span className={styles.name}>{player.name}</span>
                <span className={styles.rank}>({player.rank})</span>
            </div>
            {nextMove && <>
                <div className={styles.money}>
                    Money: 0
                </div>
                <div className={styles.mana}>
                    Mana: 0
                </div>
                <div className={styles.currentMove}>
                    {nextMove === player.label && <span className={styles.dot}/>}
                </div>
            </>}
        </section>
    )
}
