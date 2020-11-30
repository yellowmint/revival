import React, {CSSProperties} from "react"
import styles from "./board.module.scss"

interface BoardProps {
    board: TBoard
    reversed: boolean
}

export type TBoard = {
    rows: number
    columns: number
    units: Array<TUnit>
}

export type TUnit = {}

export const Board = ({board, reversed}: BoardProps) => (
    <article className={styles.board}>
        <section className={styles.wrapper}
                 style={{"--rows": board.rows, "--columns": board.columns} as CSSProperties}
        >
            {[...Array(board.rows)].map((_, rowIdx) =>
                [...Array(board.columns)].map((_, columnIdx) =>
                    <Field key={`${rowIdx}-${columnIdx}`}/>
                )
            )}
        </section>
    </article>
)


const Field = () => (
    <div className={styles.field}>
        <div className={styles.content}>

        </div>
    </div>
)
