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

export const Player = ({player, nextMove, winner, me}: PlayerProps) => {
    const [ctx, dispatch] = useContext(MoveContext)

    useEffect(() => {
        if (!player) return
        dispatch({type: "updateWallet", payload: player.wallet})
    }, [player])

    if (!player) return <></>

    const wallet = me ? ctx.wallet : player.wallet
    const isWinner = winner && player.label === winner

    return (
        <section className={`${styles.player} ${isWinner && styles.winner}`}>
            <div className={styles.playerDetails}>
                <span className={styles.name}>{player.name}</span>
                <span className={styles.rank}>({player.rank})</span>
            </div>
            {wallet && <>
                <div className={styles.money}>
                    Money: {wallet.money}
                </div>
                <div className={styles.mana}>
                    Mana: {wallet.mana}
                </div>
                <div className={styles.currentMove}>
                    <span className={`${styles.dot} ${nextMove === player.label ? styles.dotFiled : styles.dotEmpty}`}/>
                </div>
            </>}
        </section>
    )
}
