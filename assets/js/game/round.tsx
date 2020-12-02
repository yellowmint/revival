import React from "react"

interface RoundProps {
    round: number
}

export const Round = ({round}: RoundProps) => {
    if (!round) return <></>

    return (
        <section>
            Round {round}
        </section>
    )
}
