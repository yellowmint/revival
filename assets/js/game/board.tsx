import React from "react"

interface BoardProps {
    name: string
}

const Board: React.FC<BoardProps> = (props: BoardProps) => {
    const name = props.name

    return (
        <section className="phx-hero">
            <h1>Welcome to {name} with Typescript and React!</h1>
            <p>Peace-of-mind from prototype to production</p>
        </section>
    )
}

export default Board
