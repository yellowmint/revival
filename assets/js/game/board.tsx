import React, {CSSProperties, useEffect} from "react"
import styles from "./board.module.scss"
import fieldStyles from "./field.module.scss"
import {Field} from "./field"

interface BoardProps {
    board: TBoard
    reversed: boolean
}

export type TBoard = {
    rows: number
    columns: number
    units: Array<TUnit>
    revival_spots: Array<TRevivalSpot>
}

type TUnit = {}

type TRevivalSpot = {
    column: number
    row: number
    label: string
}

export const Board = ({board, reversed}: BoardProps) => {
    useEffect(() => {
        board.revival_spots.forEach(({column, row}) => {
            getField(board, reversed, column, row)?.classList.add(fieldStyles.revivalSpot)
        })
    }, [board, reversed])

    return (
        <article className={styles.board}>
            <section className={styles.wrapper}
                     style={{"--rows": board.rows, "--columns": board.columns} as CSSProperties}
            >
                {[...Array(board.rows)].map((_, rowIdx) =>
                    [...Array(board.columns)].map((_, columnIdx) =>
                        <Field key={`${columnIdx}-${rowIdx}`} column={columnIdx + 1} row={rowIdx + 1}/>
                    )
                )}
            </section>
        </article>
    )
}

function getField(board: TBoard, reversed: boolean, column: number, row: number) {
    if (reversed) {
        column = board.columns - column + 1
        row = board.rows - row + 1
    }
    return document.querySelector(`div[data-index="${column}-${row}"]`)
}
