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

    return (
        <section className={styles.board} style={{
            gridTemplateRows: `repeat(${board.rows}, 1fr)`,
            gridTemplateColumns: `repeat(${board.columns}, 1fr)`
        }}>
            {[...Array(board.rows)].map((_, rowIdx) =>
                [...Array(board.columns)].map((_, columnIdx) =>
                    <Field key={`${rowIdx}-${columnIdx}`}/>
                )
            )}
        </section>
    )
}

const Field: React.FC = () => (
    <div className={styles.field}>
        <div className={styles.content}>X</div>
    </div>
)
