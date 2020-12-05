import React, {useContext, useEffect} from "react"
import styles from "./player.module.scss"
import {MoveContext} from "./moveContext"

interface PlayerProps {
    player: TPlayer
    nextMove: string
    winner: string
    me: boolean
}

export type TPlayer = {
    id: string
    name: string
    rank: number
    label: string
    wallet: TWallet
}

export type TWallet = {
    money: number
    mana: number
}

export const Player = ({player, nextMove, winner}: PlayerProps) => {
    const [ctx, dispatch] = useContext(MoveContext)

    useEffect(() => {
        if (!player) return
        dispatch({type: "updateWallet", payload: player.wallet})
    }, [player])

    if (!player) return <></>

    const isWinner = winner && player.label === winner

    return (
        <section className={`${styles.player} ${isWinner && styles.winner}`}>
            <div className={styles.playerDetails}>
                <span className={styles.name}>{player.name}</span>
                <span className={styles.rank}>({player.rank})</span>
            </div>
            {ctx.wallet && <>
                <div className={styles.money}>
                    Money: {ctx.wallet.money}
                </div>
                <div className={styles.mana}>
                    Mana: {ctx.wallet.mana}
                </div>
                <div className={styles.currentMove}>
                    <span className={`${styles.dot} ${nextMove === player.label ? styles.dotFiled : styles.dotEmpty}`}/>
                </div>
            </>}
        </section>
    )
}
