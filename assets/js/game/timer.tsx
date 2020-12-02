import React, {CSSProperties, useEffect, useState} from "react"
import styles from "./timer.module.scss"
import {differenceInMilliseconds, parseISO} from "date-fns"

interface TimerProps {
    startedAt: string
    nextMoveDeadline: string
    roundTime: number
}

export const Timer = ({startedAt, nextMoveDeadline, roundTime}: TimerProps) => {
    const [counter, setCounter] = useState<number>()

    useEffect(() => {
        if (!startedAt) return

        const update = () => {
            const diff = differenceInMilliseconds(parseISO(startedAt), new Date())
            if (diff <= 0) {
                setCounter(0)
                return
            }

            setCounter(diff)
            setTimeout(update, 1000)
        }

        update()
    }, [startedAt, nextMoveDeadline])

    if (counter === null || counter === undefined) return <></>

    return (
        <section className={styles.timer}>
            {Math.ceil(counter / 1000)}
            {counter > 0
                ? <span className={styles.hourglass} style={{"--roundTime": `${roundTime}s`} as CSSProperties}/>
                : <span className={styles.hourglassPlaceholder}/>}
        </section>
    )
}
