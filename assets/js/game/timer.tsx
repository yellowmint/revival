import React, {CSSProperties, useEffect, useState} from "react"
import styles from "./timer.module.scss"
import {differenceInMilliseconds, parseISO} from "date-fns"
import {usePrevious} from "../utils/usePrevious"

interface TimerProps {
    nextDeadline: string
    roundTime: number
}

export const Timer = ({nextDeadline, roundTime}: TimerProps) => {
    const [counter, setCounter] = useState<number>()
    const prevDeadline = usePrevious(nextDeadline)

    const rotateHourglass = () => {
        const hourglass = document.getElementById("hourglass")
        if (hourglass) {
            hourglass.classList.remove(styles.hourglassShrink)
            void hourglass.offsetWidth
            hourglass.classList.add(styles.hourglassShrink)
        }
    }

    useEffect(() => {
        if (!nextDeadline) return
        if (nextDeadline != prevDeadline) rotateHourglass()

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

    if (counter === undefined) return <></>

    return (
        <section className={styles.timer}>
            {Math.ceil(counter / 1000)}
            <span id="hourglass"
                  className={`${styles.hourglass} ${styles.hourglassShrink}`}
                  style={{"--roundTime": `${roundTime}s`} as CSSProperties}
            />
        </section>
    )
}
