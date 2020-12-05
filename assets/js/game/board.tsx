import React, {CSSProperties, useContext, useEffect} from "react"
import styles from "./board.module.scss"
import fieldStyles from "./field.module.scss"
import {Field} from "./field"
import {MoveContext} from "./moveContext"

interface BoardProps {
    board: TBoard
    reversed: boolean
    myMove: boolean
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

export const Board = ({board, reversed, myMove}: BoardProps) => {
    const [ctx, dispatch] = useContext(MoveContext)

    useEffect(() => {
        const columnsTimes = [...Array(board.columns)]
        columnsTimes.forEach((_, idx) => {
            const field = getField(board, true, idx + 1, 1)
            myMove
                ? field?.classList.add(fieldStyles.availableToPlace)
                : field?.classList.remove(fieldStyles.availableToPlace)
        })
    }, [board, reversed, myMove])

    useEffect(() => {
        ctx.moves.forEach(move => {
            if (move.type !== "place_unit") return
            const field = getField(board, reversed, move.position.column, move.position.row)
            if (field) {
                field.classList.remove(fieldStyles.availableToPlace)
                field.innerHTML = "siema"
            }
        })
    }, [ctx.moves])

    const placeUnit = (column: number, row: number) => {
        if (!myMove) return

        column = getColumn(board.columns, reversed, column)
        row = getRow(board.rows, reversed, row)
        dispatch({type: "placeUnit", payload: {column: column, row: row}})
    }

    const isRevivalSpot = (columnIdx: number, rowIdx: number): boolean => {
        columnIdx = getColumn(board.columns, reversed, columnIdx)
        rowIdx = getRow(board.rows, reversed, rowIdx)

        return !!board.revival_spots.find(({column, row}) => column === columnIdx && row === rowIdx)
    }

    return (
        <article className={styles.board}>
            <section className={styles.wrapper}
                     style={{"--rows": board.rows, "--columns": board.columns} as CSSProperties}
            >
                {[...Array(board.rows)].map((_, i) => ++i).map(rowIdx =>
                    [...Array(board.columns)].map((_, i) => ++i).map(columnIdx =>
                        <Field key={`${columnIdx}-${rowIdx}`}
                               column={columnIdx} row={rowIdx}
                               onClick={rowIdx === board.rows ? () => placeUnit(columnIdx, rowIdx) : undefined}
                               isRevival={isRevivalSpot(columnIdx, rowIdx)}
                        />
                    )
                )}
            </section>
        </article>
    )
}

function getField(board: TBoard, reversed: boolean, column: number, row: number) {
    column = getColumn(board.columns, reversed, column)
    row = getRow(board.rows, reversed, row)
    return document.querySelector(`div[data-index="${column}-${row}"]`)
}

function getColumn(columns: number, reversed: boolean, column: number) {
    return reversed ? columns - column + 1 : column
}

function getRow(rows: number, reversed: boolean, row: number) {
    return reversed ? rows - row + 1 : row
}
