import React from "react"

interface RoundProps {
    round: number
}

export const Round = ({round}: RoundProps) => (
    <section>
        Round {round}
    </section>
)
