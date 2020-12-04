import React, {CSSProperties, useEffect, useState} from "react"
import styles from "./timer.module.scss"
import {differenceInMilliseconds, parseISO} from "date-fns"

interface TimerProps {
    nextDeadline: string
    roundTime: number
}

export const Timer = ({nextDeadline, roundTime}: TimerProps) => {
    const [counter, setCounter] = useState<number>()

    useEffect(() => {
        if (!nextDeadline) return

        let timeoutRef: number

        const tick = () => {
            const diff = differenceInMilliseconds(parseISO(nextDeadline), new Date())
            if (diff <= 0) return setCounter(0)

            setCounter(diff)
            timeoutRef = setTimeout(tick, 1000)
        }
        tick()

        return () => clearTimeout(timeoutRef)
    }, [nextDeadline])

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
