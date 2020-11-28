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

export const Board = (props: BoardProps) => {
    const board = props.board

    return (
        <article className={styles.board}>
            <section className={styles.wrapper} style={{
                gridTemplateRows: `repeat(${board.rows}, 1fr)`,
                gridTemplateColumns: `repeat(${board.columns}, 1fr)`
            }}>
                {[...Array(board.rows)].map((_, rowIdx) =>
                    [...Array(board.columns)].map((_, columnIdx) =>
                        <Field key={`${rowIdx}-${columnIdx}`}/>
                    )
                )}
            </section>
        </article>
    )
}

const Field = () => (
    <div className={styles.field}>
        <div className={styles.content}>

        </div>
    </div>
)
