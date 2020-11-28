import React from "react"
import styles from "./board.module.scss"

interface BoardProps {
    board: TBoard
}

export type TBoard = {
    rows: number
    columns: number
    fields: Array<Array<TUnit>>
}

export type TUnit = {}

export const Board: React.FC<BoardProps> = (props: BoardProps) => {
    const board = props.board
    console.log(board)

    return (
        <section className={styles.board}>
            {board.fields.map(row =>
                <div>
                    {row.map(column =>
                        <div>field</div>
                    )}
                </div>
            )}
        </section>
    )
}
